import 'FileReadWrite.dart';

writeJson(String filename, String content) async {
    var file = FileReadWrite(filename);
    await file.write(content);
}

DateTime simpleDate(DateTime date) {
  return new DateTime(date.year, date.month, date.day);
}