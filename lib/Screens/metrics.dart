import 'package:flutter/material.dart';

import '../components/LineChart.dart';

class Metrics extends StatefulWidget {
  const Metrics({Key? key}) : super(key: key);
  final String pageTitle = "Metrics";
  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            LineChartCard(),
            SizedBox(height: 20,),
            LineChartCard()
          ],
        ),
      );
  }
}