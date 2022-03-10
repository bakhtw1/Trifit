import 'package:flutter/material.dart';
import 'package:trifit/components/addfeeditem.dart';
import 'package:trifit/components/feedItem.dart';
import '../assets/Styles.dart' as tfstyle;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            Map post = posts[index];
            return FeedItem(
              dp: post['dp'],
              name: post['name'],
              desc: post['desc'],
              img: post['img'],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tfstyle.trifitColor[700],
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddFeedItem()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
