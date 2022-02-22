import 'package:flutter/material.dart';

class Challenges extends StatefulWidget {
  const Challenges({Key? key}) : super(key: key);
  final String pageTitle = "Challenges";
  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.pageTitle),
          ],
        ),
      );
  }
}