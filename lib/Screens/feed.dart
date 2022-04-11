import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trifit/components/addfeeditem.dart';
import 'package:trifit/components/feedItem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trifit/controllers/feedController.dart';
import 'package:trifit/models/FeedModel.dart';
import 'package:trifit/models/MealModel.dart';
import '../controllers/UserController.dart';
import '../utilities/Styles.dart' as tfstyle;
import '../utilities/feedData.dart';
import 'dart:io';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  final String pageTitle = "Feed";
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String text = "initial";
  late TextEditingController c;
  FeedController feedController = FeedController();

  @override
  initState() {
    c = TextEditingController();
    super.initState();
  }

  var userController = UserController();
  var feedConroller = FeedController();
  late Future<dynamic> feedData;

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('feeds').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance.collection('feeds').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Scaffold(
            body: FutureBuilder(
                future: feedConroller.getAllFeeds(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.length == 0) {
                      return Center(child: Text("Nothing to see here"));
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data[index];
                          return FeedItem(
                              dp: data['profileImageUrl'],
                              name: data['name'],
                              desc: data['desc'],
                              img: data['img']);
                        });
                  }
                }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: tfstyle.trifitColor[700],
              onPressed: () {
                setState(() {});
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddFeedItem()));
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
