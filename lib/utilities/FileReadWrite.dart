import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 
// This is a generic read/write utility that can be used in any class
// Create a new instance with `var file = FileReadWrite(<filename>)`
// Write to the file with `file.write(<some string>)`
// Read from the file with `file.read()`
// 
class FileReadWrite {
  late String fileName;

  FileReadWrite(this.fileName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> read() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> write(String contents) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$contents');
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
      return 0;
    } catch (e) {
      return 1;
    }
  }
}