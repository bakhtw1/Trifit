import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trifit/controllers/MealController.dart';
import 'package:trifit/controllers/StepController.dart';
import 'package:trifit/utilities/ColorExtentions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trifit/utilities/DateUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoubleBarChartWeeklyData extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  final String title;
  final double yExtents;

  const DoubleBarChartWeeklyData(
      {Key? key, required this.title, required this.yExtents})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DoubleBarChartWeeklyDataState();
}

class DoubleBarChartWeeklyDataState extends State<DoubleBarChartWeeklyData> {
  final Color leftBarColor = Colors.purple;
  final Color rightBarColor = Colors.black;
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

  double barYExtent = 10000;

  StepController stepController = StepController();
  MealController mealController = MealController();

  List<double> calIn = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  List<double> calOut = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  DateUtil dateUtil = DateUtil();

  List<String> daysOfWeek = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  List<String> daysOfWeekLabels = ["S", "M", "T", "W", "T", "F", "S"];

  String dateRange = "";

  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  void fillWeekData(DateTime selectedSunday) {
    print(selectedSunday.toString());
    for (int i = 0; i < 7; i++) {
      calIn[i] = mealController
          .calorieIntakeForDate(selectedSunday.add(Duration(days: i)))
          .toDouble();
      calOut[i] = stepController
          .getActiveCaloriesForDate(selectedSunday.add(Duration(days: i)))
          .toDouble();
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      dateRange = dateUtil.getWeekRange(args.value);
      fillWeekData(args.value);
      refreshState();
    });
  }

  Widget DatePicker() {
    return SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        monthViewSettings: const DateRangePickerMonthViewSettings(
            showTrailingAndLeadingDates: true),
        allowViewNavigation: true,
        view: DateRangePickerView.month,
        maxDate: dateUtil.getCurrentSaturday(),
        selectionMode: DateRangePickerSelectionMode.single,
        selectableDayPredicate: (DateTime dateTime) {
          if (dateTime.weekday == 7) {
            return true;
          }
          return false;
        },
        initialSelectedRange: PickerDateRange(
          dateUtil.getCurrentSunday(),
          dateUtil.getCurrentSaturday(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('meals')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('exercise')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (dateRange == "") {
                  dateRange = dateUtil.getWeekRange(DateTime.now());
                  fillWeekData(dateUtil.getCurrentSunday());
                }
                return AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
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
                                style: const TextStyle(
                                    color: cardTitleTextColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                dateRange,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: BarChart(
                                    mainBarData(),
                                    swapAnimationDuration: animDuration,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Card(
                                elevation: 5,
                                child: Container(
                                    child: Column(
                                  children: [
                                    Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: leftBarColor,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text("Calorie Intake"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: rightBarColor,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text("Calories Exerted"),
                                      )
                                    ]),
                                  ],
                                )),
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
                                          return Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text(
                                                  "Select Week",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: cardTitleTextColor,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: DatePicker(),
                                              )
                                            ],
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
              });
        });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2, {
    bool isTouched = false,
    Color barColor = barColor,
    double width = 10,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          y: isTouched ? y1 + 1 : y1,
          colors: isTouched ? [touchedBarColor] : [leftBarColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
        ),
        BarChartRodData(
            y: isTouched ? y2 + 1 : y2,
            colors: isTouched ? [touchedBarColor] : [rightBarColor],
            width: width,
            borderSide: isTouched
                ? BorderSide(color: touchedBarColor.darken(), width: 1)
                : const BorderSide(color: Colors.white, width: 0))
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        return makeGroupData(i, calIn[i], calOut[i],
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: tooltipBgColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = daysOfWeek[group.x.toInt()];
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
            return daysOfWeekLabels[value.toInt()];
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
