import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                            backgroundImage: NetworkImage(
                                "https://thumbs.dreamstime.com/b/portrait-young-african-american-business-woman-black-peop-people-51712509.jpg")),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'John Doe',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextField(
                    //   style: TextStyle(decoration: TextDecoration.none),
                    //   decoration: InputDecoration(
                    //     hintText: 'What would you like to share?',
                    //     border: InputBorder.none,
                    //     focusedBorder: InputBorder.none,
                    //     enabledBorder: InputBorder.none,
                    //   ),
                    //   controller: myController,
                    // ),

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
                                myController.text, imgController.text));

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
