import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileReadWrite {
  late String fileName;

  FileReadWrite(this.fileName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
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