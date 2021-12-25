import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sqflite/sqflite.dart';

class QuizDB {
  String dbName = "question.db";
  Database? _db;

  Future<Database> openDB() async {
    final databasesPath = await getDatabasesPath();
    String path = pathLib.join(databasesPath, dbName);

    if (_db == null) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    return _db as Database;
  }

  Future<void> closeDB() async {
    return _db?.close();
  }

  Future<void> ensureDB() async {
    if (_db != null) {
      await closeDB();
    }
    await openDB();
  }

  Future<void> _onCreate(Database db, int version) async {
    log("[START]: Create new database: [$dbName]");
    await initQuestion(db);
    log("[DONE]: Created database [$dbName]");
  }

  Future<void> initQuestion(Database db) async {
    String tableName = 'question';
    return db.transaction((txn) async {
      String sql = "CREATE TABLE $tableName(" +
          "id INTEGER PRIMARY KEY, " +
          "question TEXT DEFAULT '', " +
          "imageurl TEXT DEFAULT '', " +
          "correct INT DEFAULT -1, " +
          "answer1 TEXT DEFAULT '', " +
          "answer2 TEXT DEFAULT '', " +
          "answer3 TEXT DEFAULT '', " +
          "answer4 TEXT DEFAULT '', " +
          "type INT DEFAULT -1)";

      await txn.execute(sql);

      final rows = await getDataFromAsset("assets/db_resource/question.tsv");

      for (int i = 0; i < rows.length; i++) {
        var row = rows[i];
        row["id"] = int.parse(row["id"].toString());
        row["correct"] = int.parse(row["correct"].toString());
        row["type"] = int.parse(row["type"].toString());

        await txn.insert(tableName, row);
      }
    }).then((value) => log("[OK]: Init table $tableName"));
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

  Future<QuestionModel?> getQuestion(int id) async {
    //debugPrint("Db size  = " + (await io.File(await getDBPath()).length()).toString());
    debugPrint("Get quiz no." + id.toString());

    var db = await this.openDB();
    var sql = "SELECT * FROM [question] WHERE id = ?;";
    var result = await db.rawQuery(sql, [id]);
    await db.close();

    if (result.isEmpty) {
      return null;
    } else {
      return QuestionModel.fromMap(result.first);
    }
  }

  Future<List<QuestionModel>> getQuestionList(List<int> idList) async {
    var db = await openDB();
    var argsPlaceholder = idList.map((e) => "?").join(",");
    var sql = "SELECT * FROM [question] WHERE id IN ($argsPlaceholder);";
    var result = await db.rawQuery(sql, idList);
    await db.close();

    var rs = List.generate(
        result.length, (index) => QuestionModel.fromMap(result[index]));
    return rs;
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
