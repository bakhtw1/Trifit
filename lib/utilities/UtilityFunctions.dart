import 'package:cloud_firestore/cloud_firestore.dart';

import 'FileReadWrite.dart';

writeJson(String filename, String content) async {
    var file = FileReadWrite(filename);
    await file.write(content);
}

DateTime simpleDate(DateTime date) {
  return new DateTime(date.year, date.month, date.day);
}

Timestamp dateToTimestamp(DateTime date) {
  return Timestamp.fromDate(date);
}

DateTime dateFromTimestamp(Timestamp date) {
  return date.toDate();
}