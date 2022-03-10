import 'package:intl/intl.dart';

class DateUtil {
  DateTime currentDay = DateTime.now();
  final DateFormat MMMD = DateFormat("MMMd");

  DateUtil() {}

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

  DateTime getCurrentSaturday() {
    return getCurrentSunday().add(const Duration(days: 6));
  }

  String getWeekRange(DateTime dt) {
    DateTime sunOfWeek = dt;
    DateTime satOfWeek = dt.add(const Duration(days: 6));

    return formatMMMD(sunOfWeek) + " - " + formatMMMD(satOfWeek);
  }
}
