import 'package:flutter/material.dart';

class Metrics extends StatefulWidget {
  const Metrics({Key? key}) : super(key: key);
  final String pageTitle = "Metrics";
  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {

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