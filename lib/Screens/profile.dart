import 'package:flutter/material.dart';
import '../assets/Styles.dart';
import '../data/profile.dart';
import '../components/friendList.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  final String pageTitle = "Profile";
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
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
                  profileData["imageUrl"],
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
                    child: Text("Following: ${profileData["numFollowing"]} | "),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendList(
                            title: "Following",
                            friends: profileData["following"],
                          ),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Text("Followers: ${profileData["numFollowers"]}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendList(
                            title: "Followers",
                            friends: profileData["followers"],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Gender:"),
                                Text("Weight(lb):"),
                                Text("Age:"),
                                Text("Height:"),
                                Text("Date Joined:")
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(profileData["gender"]),
                                Text(profileData["weight"].toString()),
                                Text(profileData["age"].toString()),
                                Text(profileData["height"]),
                                Text(profileData["dateJoined"]),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Fitness Style:"),
                                Text("Total Calories Burned:"),
                                Text("Desired Weight:"),
                                Text("Challenges Completed:")
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(profileData["fitnessStyle"]),
                                Text(profileData["caloriesBurned"].toString()),
                                Text(profileData["desiredWeight"].toString()),
                                Text(profileData["challengesCompleted"]
                                    .toString()),
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile["name"]);
    _weightController =
        TextEditingController(text: widget.profile["weight"].toString());
    _ageController =
        TextEditingController(text: widget.profile["age"].toString());
    _desiredWeightController =
        TextEditingController(text: widget.profile["desiredWeight"].toString());
    _fitnessStyleController =
        TextEditingController(text: widget.profile["fitnessStyle"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _desiredWeightController.dispose();
    super.dispose();
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
              backgroundImage: NetworkImage(widget.profile["imageUrl"]),
              child: Stack(
                children: const [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.edit),
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
                  widget.profile["weight"] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Age',
              ),
              onChanged: (String value) {
                setState(() {
                  widget.profile["Age"] = value;
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
            const SizedBox(height: 100),
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
                    onPressed: () {
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
