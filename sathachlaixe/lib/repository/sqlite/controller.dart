import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathLib;

class DBController {
  String dbName = "luyenthib1.db";
  Database? _db;

  Future<Database> openDB() async {
    final databasesPath = await getDatabasesPath();
    String path = PathLib.join(databasesPath, dbName);

    if (_db == null) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    return _db as Database;
  }

  Future<void> _onCreate(Database db, int version) async {
    log("Create new database");
    String sql1 = "CREATE TABLE history(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "create_time INTEGER DEFAULT NULL, " +
        "update_time INTEGER DEFAULT NULL, " +
        "sync_time INTEGER DEFAULT NULL, " +
        "topicID INTEGER DEFAULT -1, " +
        "isPassed INTEGER DEFAULT 0, " +
        "isFinished INTEGER DEFAULT 0, " +
        "timeLeft INTEGER DEFAULT 0, " +
        "rawQuestionIDs TEXT DEFAULT '', " +
        "rawCorrect TEXT DEFAULT '', " +
        "rawSelected TEXT DEFAULT '' " +
        ")";
    String sql2 = "CREATE TABLE practice(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "create_time INTEGER DEFAULT NULL, " +
        "update_time INTEGER DEFAULT NULL, " +
        "sync_time INTEGER DEFAULT NULL, " +
        "topicID INTEGER DEFAULT -1, " +
        "questionID INTEGER DEFAULT -1, " +
        "selectedAnswer INTEGER DEFAULT 0, " +
        "correctAnswer INTEGER DEFAULT 0, " +
        "countWrong INTEGER DEFAULT 0, " +
        "countCorrect INTEGER DEFAULT 0 " +
        ")";
    await db.execute(sql1).then((value) => log("CREATE history: [OK]"));
    await db.execute(sql2).then((value) => log("CREATE practice: [OK]"));
  }

  Future<void> closeDB() async {
    return _db?.close();
  }

  void changeMode(String mode) {
    if (dbName == "luyenthi$mode.db") return;

    dbName = "luyenthi$mode.db";
    closeDB().then((value) => openDB());
  }
}

class B1Database extends DBController {
  B1Database() {
    this.dbName = "luyenthib1.db";
  }
}

class B2Database extends DBController {
  B2Database() {
    this.dbName = "luyenthib2.db";
  }
}
