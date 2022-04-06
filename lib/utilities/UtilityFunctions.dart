import 'package:cloud_firestore/cloud_firestore.dart';

DateTime simpleDate(DateTime date) {
  return new DateTime(date.year, date.month, date.day);
}

Timestamp dateToTimestamp(DateTime date) {
  return Timestamp.fromDate(date);
}

DateTime dateFromTimestamp(Timestamp date) {
  return date.toDate();
}