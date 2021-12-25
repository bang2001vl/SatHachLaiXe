import 'dart:developer';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/repository/sqlite/boardCategoryController.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathLib;

import 'boardController.dart';

class AppDBController {
  String dbName = "app.db";
  static final String _tableConfig = "config";
  Database? _db;

  Future<Database> openDB() async {
    final databasesPath = await getDatabasesPath();
    String path = PathLib.join(databasesPath, dbName);

    if (_db == null) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    return _db as Database;
  }

  Future<void> closeDB() async {
    return _db?.close();
  }

  Future<void> _onCreate(Database db, int version) async {
    log("Create new database: [app]");

    await initConfig(db);
    await initBoard(db);
    await initBoardCate(db);

    log("[OK]: Created database app");
  }

  Future<void> initConfig(Database db) async {
    String sql = "CREATE TABLE $_tableConfig(" +
        "key TEXT PRIMARY KEY NOT NULL, " +
        "value TEXT DEFAULT NULL " +
        ")";
    await db.execute(sql);
    await db.insert(_tableConfig, {
      "key": "mode",
      "value": "b1",
    });

    log("[OK]: Init table config");
  }

  Future<void> initBoard(Database db) async {
    String tableName = 'board';
    return db.transaction((txn) async {
      String sql = "CREATE TABLE $tableName(" +
          "id INTEGER PRIMARY KEY, " +
          "cateId INTEGER DEFAULT 0, " +
          "name TEXT DEFAULT '', " +
          "detail TEXT DEFAULT '', " +
          "assetURL TEXT DEFAULT '')";

      await txn.execute(sql);

      final rows = await getDataFromAsset("assets/db_resource/board.tsv");

      for (int i = 0; i < rows.length; i++) {
        var row = rows[i];
        row["id"] = int.parse(row["id"].toString());
        row["cateId"] = int.parse(row["cateId"]!.toString());
        await txn.insert(tableName, row);
      }
    }).then((value) => log("[OK]: Init table board"));
  }

  Future<void> initBoardCate(Database db) async {
    String tableName = 'boardCate';
    return db.transaction((txn) async {
      String sql = "CREATE TABLE $tableName("
          "id INTEGER PRIMARY KEY, "
          "name TEXT DEFAULT '', "
          "detail TEXT DEFAULT '', "
          "assetURL TEXT DEFAULT '')";

      await txn.execute(sql);

      final rows = await getDataFromAsset("assets/db_resource/boardCate.tsv");

      for (int i = 0; i < rows.length; i++) {
        var row = rows[i];
        row["id"] = int.parse(row["id"].toString());
        await txn.insert(tableName, row);
      }
    }).then((value) => log("[OK]: Init table boardCate"));
  }
}

class AppController {
  String tableName = "config";

  Future<String> getMode() async {
    var db = await AppDBController().openDB();
    String sql = "SELECT value FROM $tableName WHERE key = 'mode' LIMIT 1";
    var reader = await db.rawQuery(sql);
    return reader.first["value"] as String;
  }

  Future<int> updateMode(String mode) async {
    var db = await AppDBController().openDB();
    String sql = "UPDATE $tableName SET value = ? WHERE key = 'mode'";
    return db.rawUpdate(sql, [mode]);
  }
}
