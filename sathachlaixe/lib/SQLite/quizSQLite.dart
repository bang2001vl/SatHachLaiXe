import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuizDB {
  static const String dbName = "final.db";

  QuizDB();

  Future<void> ensureDB() async {
    debugPrint("DATABASE: onEnsure");
    final path = await getDBPath();
    if (io.FileSystemEntity.typeSync(path) ==
        io.FileSystemEntityType.notFound) {
      debugPrint("DATABASE: Not found db file. Starting copy db from bundle");
      await copyDBto(path);
    }
    debugPrint("DATABASE: Ensure OK");
  }

  Future<String> getDBPath() async {
    final dbDir = await getDatabasesPath();
    return join(dbDir, dbName);
  }

  Future<void> copyDBto(String path) async {
    ByteData data = await rootBundle.load("assets/final.db");
    if (data.lengthInBytes > 10) debugPrint("Found in bundle");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await io.File(path).writeAsBytes(bytes);
  }

  Future<Database> openDB() async {
    final path = await getDBPath();
    return openDatabase(path);
  }

  Future<QuizBaseDB> findQuizById(int id) async {
    //debugPrint("Db size  = " + (await io.File(await getDBPath()).length()).toString());
    debugPrint("Get quiz no." + id.toString());
    var db = await openDB();
    var sql = "SELECT * FROM [question] WHERE id = ?;";
    var result = await db.rawQuery(sql, [id]);
    await db.close();
    return QuizBaseDB.fromMap(result.first);
  }
}

class QuizBaseDB {
  int id;
  String question;
  String imageurl;
  int correct;
  List<String> answers = List.empty();
  int type;

  QuizBaseDB(this.id, this.question, this.imageurl, this.correct, this.answers,
      this.type);

  Map<String, dynamic> toMap() {
    return Map.of({
      'id': id,
      'question': question,
      'imageurl': imageurl,
      'correct': correct,
      'answer1': answers[0],
      'answer2': answers[1],
      'answer3': answers[2],
      'answer4': answers[3],
      'type': type,
    });
  }

  factory QuizBaseDB.fromMap(Map<String, dynamic> map) {
    var answers = List<String>.from({
      map['answer1'],
      map['answer2'],
      map['answer3'],
      map['answer4'],
    });
    if (answers.length > 3 && answers[3] == "") answers.removeAt(3);
    if (answers.length > 2 && answers[2] == "") answers.removeAt(2);
    return new QuizBaseDB(
        map['id'] as int,
        map['question'] as String,
        map['imageurl'] as String,
        map['correct'] as int,
        answers,
        map['type'] as int);
  }

  factory QuizBaseDB.getMock() {
    return new QuizBaseDB(
        301,
        "Khi động cơ ô tô đã khởi động, bảng đồng hồ xuất hiện ký hiệu như hình vẽ dưới đây không tắt trong thời gian dài, báo hiệu tình trạng như thế nào của xe ô tô?",
        "https://i-vnexpress.vnecdn.net/2020/09/04/q301.png",
        4,
        List<String>.from({
          "Nhiệt độ nước làm mát động cơ quá ngưỡng cho phép.",
          "Áp suất lốp không đủ.",
          "Đang hãm phanh tay.",
          "Hệ thống lái gặp trục trặc.",
        }),
        0);
  }

  QuizBaseDB.from({
    required this.id,
    required this.question,
    required this.imageurl,
    required this.correct,
    required this.answers,
    required this.type,
  });
}
