import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../assets/Styles.dart';
import '../components/dropdown.dart';


class Challenges extends StatefulWidget {
  const Challenges({Key? key}) : super(key: key);
  final String pageTitle = "Challenges";
  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  //To be moved to data
  List challenges = [];

  @override
  Widget build(BuildContext context) {
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
              children: [
                for (var i in challenges) challengeCard(i)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: trifitColor[700],
        onPressed: () async {
            showMealEntryDialog(() => {
              setState(() {})
            });
        },
        tooltip: 'Edit',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showMealEntryDialog(reload) {
    final _formKey = GlobalKey<FormState>();
    String challengeTypeDropdownValue = "";
    TextEditingController distanceTextController = TextEditingController();
  
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('New challenge'),
              content: Container(
                width: MediaQuery.of(context).size.width*0.8,
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
                                  onValueSelected: (String value) { challengeTypeDropdownValue = value; },
                                  dropdownOptions: ["Walk", "Run", "Bike"],
                                  placeholderText: "Challenge Type",
                                  flex: 3,
                                ),
                              ),
                            ],
                          )
                        ), 
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: distanceTextController,
                            decoration: InputDecoration(hintText: "Distance in km"),
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
                        )
                      ],
                    ),
                  ),
                )
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      challenges.add({
                        "challengeText": challengeTypeDropdownValue+" "+distanceTextController.text+" km",
                        "challengeType": challengeTypeDropdownValue,
                        "challengeProgress": Random().nextInt(100)/100,
                      });
                      reload();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Container challengeCard(challengeData) => Container(
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 5,
                top: 5,
                bottom: 5
              ),
              child: Icon(
                getIcon(challengeData["challengeType"]),
                size: 40,
              ),
            ),
            Expanded(child: Container()),
            Column(
              children: [
                Text(
                  challengeData["challengeText"],
                  style: TextStyle(fontSize: 15)
                ),
                Container(height: 2,),
                progressBar(challengeData["challengeProgress"])
              ],
            ),
            Expanded(child: Container()),
          ],
        )
      ),
    ),
  );

  IconData getIcon(String icon) {
    if(icon == "Walk") {
      return Icons.directions_walk;
    }
    else if(icon == "Run") { 
      return Icons.directions_run;
    }
    else {
      return Icons.directions_bike;
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