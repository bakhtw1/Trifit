import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trifit/data/profile.dart';
import '../models/WeightModel.dart';
import '../models/ProfileModel.dart';
import '../utilities/Styles.dart';
import '../components/friendList.dart';
import '../controllers/UserController.dart';
import '../controllers/StepController.dart';
import '../controllers/WeightController.dart';
import '../controllers/ChallengeController.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  final String pageTitle = "Profile";
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userController = UserController();
  var stepController = StepController();
  var challengeController = ChallengeController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var profileData = userController.getUser();
        var registrationDate = DateFormat('dd/MM/yyyy')
            .format(profileData['registrationDate'].toDate());
        var height = profileData['height'];
        return Stack(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      profileData["imageURL"],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    profileData["name"],
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                            "Following: ${profileData["following"].length} | "),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendList(
                                title: "Following",
                                isFollowingScreen: true,
                                followingList: profileData["following"],
                                followersList: profileData["followers"],
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Text(
                            "Followers: ${profileData["followers"].length}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendList(
                                title: "Followers",
                                isFollowingScreen: false,
                                followingList: profileData["following"],
                                followersList: profileData["followers"],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Personal Info",
                              style: TextStyle(fontSize: 26)),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Gender:"),
                                    Text("Weight(lb):"),
                                    Text("Age:"),
                                    Text("Height:"),
                                    Text("Date Joined:")
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(toBeginningOfSentenceCase(
                                            profileData["gender"])
                                        .toString()),
                                    Text(profileData["weight"].toString()),
                                    Text(profileData["age"].toString()),
                                    Text(height),
                                    Text(registrationDate.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Fitness Info",
                            style: TextStyle(fontSize: 26),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Fitness Style:"),
                                    Text("Total Calories Burned:"),
                                    Text("Desired Weight:"),
                                    Text("Active Challenges:")
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(profileData['fitnessStyle']),
                                    Text(
                                      stepController
                                          .getAllCaloriesBurned()
                                          .toString(),
                                    ),
                                    Text(profileData['desiredWeight']),
                                    Text(
                                      challengeController
                                          .getAllChallenges()
                                          .length
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: trifitColor[700],
                onPressed: () async {
                  final profile = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(profile: profileData),
                    ),
                  );
                  setState(() {
                    profileData = profile;
                  });
                },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.profile}) : super(key: key);

  final Map profile;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  late TextEditingController _desiredWeightController;
  late TextEditingController _fitnessStyleController;
  late TextEditingController _heightController;
  late TextEditingController _imageURLController;
  var userController = UserController();
  bool isWeightChanged = false;
  var weightController = WeightController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile["name"]);
    _weightController = TextEditingController(text: widget.profile["weight"]);
    _ageController = TextEditingController(text: widget.profile["age"]);
    _desiredWeightController =
        TextEditingController(text: widget.profile["desiredWeight"]);
    _fitnessStyleController =
        TextEditingController(text: widget.profile["fitnessStyle"]);
    _heightController = TextEditingController(text: widget.profile["height"]);
    _imageURLController =
        TextEditingController(text: widget.profile["imageURL"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _desiredWeightController.dispose();
    super.dispose();
  }

  String url = "";
  String holderURL = "";

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Image'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  holderURL = value;
                });
              },
              controller: _imageURLController,
              decoration: const InputDecoration(hintText: "URL"),
            ),
            actions: <Widget>[
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(trifitColor[900]),
                ),
                onPressed: () {
                  setState(() {
                    widget.profile["imageURL"] = holderURL;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(widget.profile["imageURL"]),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Update Profile Picture',
                        onPressed: () {
                          _displayTextInputDialog(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              onChanged: (String value) {
                setState(() {
                  widget.profile["name"] = value;
                });
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Weight',
              ),
              onChanged: (String value) {
                setState(() {
                  isWeightChanged = true;
                  widget.profile["weight"] = value;
                });
              },
            ),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Height (feet)',
              ),
              onChanged: (String value) {
                setState(() {
                  widget.profile["height"] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: widget.profile["gender"],
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.grey,
                padding: const EdgeInsets.only(top: 100),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  widget.profile["gender"] = newValue!;
                });
              },
              items: <String>['male', 'female', 'unspecified']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Age',
              ),
              onChanged: (String value) {
                setState(() {
                  widget.profile["age"] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _desiredWeightController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Desired Weight',
              ),
              onChanged: (String value) {
                setState(() {
                  widget.profile["desiredWeight"] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fitnessStyleController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Fitness Style',
              ),
              onChanged: (String value) {
                setState(() {
                  widget.profile["fitnessStyle"] = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await userController.updateUser(
                        ProfileModel(
                          widget.profile["name"],
                          widget.profile["weight"],
                          widget.profile["age"],
                          widget.profile["desiredWeight"],
                          widget.profile["fitnessStyle"],
                          widget.profile['height'],
                          widget.profile['gender'],
                          widget.profile['imageURL'],
                        ),
                      );
                      if (isWeightChanged) {
                        await weightController.addWeight(WeightModel(
                          widget.profile["weight"],
                          DateTime.now(),
                        ));
                      }
                      Navigator.of(context).pop(widget.profile);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
