import 'package:flutter/material.dart';
import 'package:trifit/components/BarChart.dart';
import 'package:trifit/components/DoubleBarChart.dart';
import 'package:trifit/components/WeightChart.dart';

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
        children: const <Widget>[
          WeeklyDataBarChart(
            title: "Daily Steps",
            yExtents: 10000,
          ),
          DoubleBarChartWeeklyData(title: "Calories", yExtents: 5000),
          WeightMetrics(title: "Weight")
        ],
      ),
    );
  }
}
