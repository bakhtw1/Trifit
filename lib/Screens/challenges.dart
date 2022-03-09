import 'package:flutter/material.dart';
import '../assets/Styles.dart';

class Challenges extends StatefulWidget {
  const Challenges({Key? key}) : super(key: key);
  final String pageTitle = "Challenges";
  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  //To be moved to data
  List challenges = [];

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
              for (var i in challenges) challengeCard("Walk 100 miles")
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: trifitColor[700],
            onPressed: () {
              setState(() {
                challenges.add({"challengeText": "Run 100 miles"});
              });
            },
            tooltip: 'Edit',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Container challengeCard(String challText) => Container(
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.run_circle
                  ),
                  Text(
                    challText,
                    style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}