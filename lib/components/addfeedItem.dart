import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trifit/controllers/UserController.dart';
import 'package:trifit/models/FeedModel.dart';

import '../controllers/feedController.dart';

class AddFeedItem extends StatefulWidget {
  AddFeedItem({Key? key}) : super(key: key);

  @override
  State<AddFeedItem> createState() => _AddFeedItemState();
}

class _AddFeedItemState extends State<AddFeedItem> {
  var myController = TextEditingController();
  var imgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // CollectionReference feeds = FirebaseFirestore.instance.collection("feeds");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    imgController.dispose();
    super.dispose();
  }

  var feedController = FeedController();
  var userController = UserController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('meals')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var name = userController.user['name'];
          var imageURL = userController.user['imageURL'];

          return Scaffold(
            appBar: AppBar(title: Text('Create Post')),
            body: Padding(
              padding: EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(userController.user['imageURL'])),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          userController.user['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: myController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'What would you like to share?',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some description for the post';
                        }
                        return null;
                      },
                    ),
                    TextField(
                      controller: imgController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter image URL',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        // onPressed: () async {
                        //   await feeds.add({'description': myController.text}).then(
                        //       (value) => print('feed added'));
                        // },
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await feedController.addFeed(FeedModel(
                                name,
                                myController.text,
                                imgController.text,
                                imageURL,
                                DateTime.now()));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Successfully added post')),
                            );
                          }
                        },
                        child: Text('Share'))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
