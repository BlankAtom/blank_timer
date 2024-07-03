import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 获取文件路径
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 创建文件
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/databaseInfo.json');
}

// 读取文件
Future<String> readFile() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return "[]";
  }
}

// 写入文件
Future<File> writeFile(String content) async {
  final file = await _localFile;
  return file.writeAsString(content);
}