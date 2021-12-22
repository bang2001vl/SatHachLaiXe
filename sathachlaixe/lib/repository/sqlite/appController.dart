import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathLib;

class _AppDBController {
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

  Future<void> _onCreate(Database db, int version) async {
    log("Create new database: [app]");
    String sql1 = "CREATE TABLE $_tableConfig(" +
        "key TEXT PRIMARY KEY NOT NULL, " +
        "value TEXT DEFAULT NULL " +
        ")";
    await db.execute(sql1).then((value) => log("CREATE app: [OK]"));
    await db.insert(_tableConfig, {
      "key": "mode",
      "value": "b1",
    });
  }

  Future<void> closeDB() async {
    return _db?.close();
  }
}

class AppController {
  String tableName = "config";

  Future<String> getMode() async {
    var db = await _AppDBController().openDB();
    String sql = "SELECT value FROM $tableName WHERE key = 'mode' LIMIT 1";
    var reader = await db.rawQuery(sql);
    return reader.first["value"] as String;
  }

  Future<int> updateMode(String mode) async {
    var db = await _AppDBController().openDB();
    String sql = "UPDATE $tableName SET value = ? WHERE key = 'mode'";
    return db.rawUpdate(sql, [mode]);
  }
}
