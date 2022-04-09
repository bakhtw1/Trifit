import 'dart:async';

import 'package:intl/intl.dart';

class DateUtil {
  DateTime currentDay = DateTime.now();
  final DateFormat MMMD = DateFormat("MMMd");

  DateUtil() {
    DateTime now = DateTime.now();
    currentDay = DateTime(now.year, now.month, now.day);
  }

  String formatMMMD(DateTime dt) {
    return MMMD.format(dt);
  }

  DateTime getCurrentSunday() {
    DateTime sundayOfWeek =
        currentDay.subtract(Duration(days: currentDay.weekday));

    if (currentDay.weekday == 7) {
      sundayOfWeek = currentDay;
    }

    return sundayOfWeek;
  }

  DateTime getSundayOfWeek(DateTime dt) {
    DateTime sundayOfWeek = dt.subtract(Duration(days: dt.weekday));

    if (dt.weekday == 7) {
      sundayOfWeek = dt;
    }

    return sundayOfWeek;
  }

  DateTime getSaturdayOfWeek(DateTime dt) {
    DateTime saturdayOfWeek = dt.add(Duration(days: 6));
    return saturdayOfWeek;
  }

  DateTime getCurrentSaturday() {
    return getCurrentSunday().add(const Duration(days: 6));
  }

  String getWeekRange(DateTime dt) {
    DateTime sunOfWeek = getSundayOfWeek(dt);
    DateTime satOfWeek = sunOfWeek.add(const Duration(days: 6));

    return formatMMMD(sunOfWeek) + " - " + formatMMMD(satOfWeek);
  }
}
