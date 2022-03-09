import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trifit/utilities/ColorExtentions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trifit/utilities/DateUtil.dart';

class WeightMetrics extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  final String title;

  const WeightMetrics({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeightMetricsState();
}

class WeightMetricsState extends State<WeightMetrics> {
  final Color barBackgroundColor = const Color(0xffd7a1f9);
  final Color cardBackgroundColor = Colors.white;
  static const Color cardTitleTextColor = Colors.purple;
  static const Color cardSubtitleTextColor = Colors.deepPurple;
  static const Color barColor = Colors.purple;
  static const Color touchedBarColor = Colors.purple;
  static const Color tooltipBgColor = Colors.deepPurple;
  static const Color tooltipTitleTextColor = Colors.white;
  static const Color tooltipChildTextColor = Colors.white;
  static const Color barLabelTextColor = Colors.black;

  double barYExtent = 250;

  List<double> weekData = [
    200,
    190,
    195,
    190,
    187,
    185,
    180,
    182,
    177,
    175,
    180,
    175
  ];

  DateUtil dateUtil = DateUtil();

  String year = "";
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> monthLabels = [
    "J",
    "F",
    "M",
    "A",
    "M",
    "J",
    "J",
    "A",
    "S",
    "O",
    "N",
    "D"
  ];

  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  void _onSelectionChanged() {
    setState(() {
      refreshState();
    });
  }

  Widget DatePicker() {
    List<Widget> items = [];

    int currentYear = DateTime.now().year;
    for (int i = currentYear; i > 2000; i--) {
      items.add(ListTile(
        onTap: () {
          setState(() {
            for (int i = 0; i < weekData.length; i++) {
              weekData[i] = Random().nextInt(10).toDouble() + 170;
            }
            year = i.toString();
            refreshState();
            Navigator.of(context).pop();
          });
        },
        title: Text(
          i.toString(),
          textAlign: TextAlign.center,
        ),
      ));
    }
    return Container(
      width: 250,
      height: 100,
      child: ListView(children: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (year == "") {
      year = DateTime.now().year.toString();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: cardTitleTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    year,
                    style: TextStyle(
                        color: cardSubtitleTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: ((context, setState) {
                              return Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "Select Year",
                                        style: TextStyle(
                                            color: cardTitleTextColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    DatePicker()
                                  ],
                                ),
                              );
                            }));
                          });
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [touchedBarColor] : [barColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: barYExtent,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
        return makeGroupData(i, weekData[i], isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: tooltipBgColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = months[group.x.toInt()];
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: tooltipTitleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toInt().toString(),
                    style: const TextStyle(
                      color: tooltipChildTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: barLabelTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return monthLabels[value.toInt()];
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
  }
}
