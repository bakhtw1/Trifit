import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trifit/components/addfeeditem.dart';
import 'package:trifit/components/feedItem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trifit/controllers/feedController.dart';
import 'package:trifit/models/FeedModel.dart';
import 'package:trifit/models/MealModel.dart';
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

  @override
  initState() {
    c = TextEditingController();
    super.initState();
  }

  var feedConroller = FeedController();
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('feeds').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return Scaffold(
            // body: ListView.builder(
            //     itemCount: posts.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       Map post = posts[index];
            //       return FeedItem(
            //         dp: post['dp'],
            //         name: feedConroller.allFeeds.desc,
            //         desc: post['desc'],
            //         img: post['img'],
            //       );
            //     }),

            body: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Text('something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }

                final data = snapshot.requireData;
                return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Text(data.docs[index]['desc']);
                    });
              },
            ),
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
