import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathLib;

class DBController {
  static final _instance = DBController._internal();
  factory DBController() {
    return _instance;
  }

  DBController._internal(){
    openDB();
  }

  Database? _db;

  Future<Database> openDB() async {
    final databasesPath = await getDatabasesPath();
    String path = PathLib.join(databasesPath, "luyenthi.db");

    if (_db == null) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    return _db as Database;
  }

  void _onCreate(Database db, int version) {
    log("Create new database");
    String sql1 = "CREATE TABLE history (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "create_time INTEGER DEFAULT CURRENT_TIMESTAMP, " +
        "sync_time INTEGER DEFAULT NULL, " +
        "topicID INTEGER DEFAULT -1, " +
        "isPassed INTEGER DEFAULT 0, " +
        "rawQuestionIDs TEXT DEFAULT '', " +
        "rawCorrect TEXT DEFAULT '', " +
        "rawSelected TEXT DEFAULT '' " +
        ")";
    db.execute(sql1);
  }

  void closeDB() async {
    await _db?.close();
  }
}
