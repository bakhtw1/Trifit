import 'package:flutter/material.dart';
import '../assets/Styles.dart' as tfstyle;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  final String pageTitle = "Feed";
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: tfstyle.trifitColor[700],
        onPressed: () {
          //do something
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
