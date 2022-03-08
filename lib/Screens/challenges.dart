import 'package:flutter/material.dart';
import '../assets/Styles.dart';

class Challenges extends StatefulWidget {
  const Challenges({Key? key}) : super(key: key);
  final String pageTitle = "Challenges";
  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: trifitColor[700],
            onPressed: () {},
            tooltip: 'Add challenge',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Container challengeCard(challengeText) => Container(
    child: Card(
      child: Text(challengeText),
    ),
  );
}