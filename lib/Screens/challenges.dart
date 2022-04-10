import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trifit/models/ChallengeModel.dart';
import 'package:trifit/utilities/DateUtil.dart';
import '../utilities/Styles.dart';
import '../components/dropdown.dart';
import '../controllers/ChallengeController.dart';
import '../controllers/StepController.dart';
import '../utilities/UtilityFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Challenges extends StatefulWidget {
  const Challenges({Key? key}) : super(key: key);
  final String pageTitle = "Challenges";
  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  //To be moved to data
  List challenges = [];
  var challengeController = ChallengeController();
  var stepController = StepController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('meals')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var allChallenges = challengeController.getAllChallenges();
        for(var challenge in allChallenges) { 
          //calculate progress for progress bar
          challenge["stepProgress"] = stepController.getStepsFromDateForPastDays(DateTime.parse(challenge["end"]), challenge["duration"]) / challenge["amount"];
          if(challenge["stepProgress"] < 1 && DateTime.now().isAfter(DateTime.parse(challenge["end"]))) {
            //failed
            challenge["status"] = "Failed";
          }
          else if(challenge["stepProgress"] >= 1 ) {
            //successful
            challenge["status"] = "Completed";
          }
          else {
            //in progress
            challenge["status"] = "Active";
          }
        }

        return Scaffold(
          body: Stack(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
                margin: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [for (var i in allChallenges) challengeCard(i)],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: trifitColor[700],
            onPressed: () async {
              showMealEntryDialog(() => {setState(() {})});
            },
            tooltip: 'Edit',
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }

  void showMealEntryDialog(reload) {
    final _formKey = GlobalKey<FormState>();
    String challengeTypeDropdownValue = "";
    TextEditingController distanceTextController = TextEditingController();
    TextEditingController durationTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('New challenge'),
            content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Container(
                                  child: DropdownMenu(
                                    onValueSelected: (String value) {
                                      challengeTypeDropdownValue = value;
                                    },
                                    dropdownOptions: ["Walk"],
                                    placeholderText: "Challenge Type",
                                    flex: 3,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: distanceTextController,
                            decoration:
                                InputDecoration(hintText: "Number of steps"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (num.tryParse(value) == null) {
                                return 'Must be number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: durationTextController,
                            decoration:
                                InputDecoration(hintText: "Number of days"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (num.tryParse(value) == null) {
                                return 'Must be number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    challenges.add({
                      "challengeText": challengeTypeDropdownValue +
                          " " +
                          distanceTextController.text +
                          " km",
                      "challengeType": challengeTypeDropdownValue,
                      "duration": durationTextController.text,
                      "challengeProgress": Random().nextInt(100) / 100,
                    });
                    ChallengeModel toAdd = ChallengeModel("Walk", int.parse(distanceTextController.text), int.parse(durationTextController.text), DateTime.now(), DateTime.now().add(Duration(days: int.parse(durationTextController.text))));
                    challengeController.addChallenge(toAdd, DateTime.now());
                    reload();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  Container challengeCard(challengeData) => Container(
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: getIcon(challengeData["status"]),
                  ),
                  Expanded(child: Container()),
                  Column(
                    children: [
                      Text(challengeData["type"] + " " + challengeData["amount"].toString() + " steps in " + challengeData["duration"].toString() + " days",
                          style: TextStyle(fontSize: 15)),
                      Container(
                        height: 2,
                      ),
                      Text((challengeData["status"] == "Active")? timeRemaining(challengeData["end"]) + " remaining" : challengeData["status"],
                          style: TextStyle(fontSize: 15)),
                      Container(
                        height: 2,
                      ),
                      progressBar(challengeData["stepProgress"])
                    ],
                  ),
                  Expanded(child: Container()),
                ],
              )),
        ),
      );

  String timeRemaining(String date) {
    var diff = DateTime.parse(date).difference(DateTime.now());

    if(diff.inDays >= 1) {
      return diff.inDays.toString() + " days";
    }
    else {
      return diff.inHours.toString() + " hours";
    }
  }

  Icon getIcon(String icon) {
    if (icon == "Active") {
      return Icon(
        Icons.directions_walk,
        color: Colors.black,
        size: 40,
      );
    } else if (icon == "Completed") {
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 40,
      );
    } else {
      return Icon(
        Icons.close,
        color: Colors.red,
        size: 40,
      );
    }
  }

  Container progressBar(percent) => Container(
        
        height: 25,
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.grey.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  color: trifitColor[700],
                  height: 19,
                  width: MediaQuery.of(context).size.width * 0.4 * percent,
                ),
              ),
            ],
          ),
        ),
      );
}
