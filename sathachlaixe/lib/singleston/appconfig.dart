import 'package:sathachlaixe/repository/mode/b1.dart';
import 'package:sathachlaixe/repository/mode/b2.dart';
import 'package:sathachlaixe/repository/mode/base.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/repository/sqlite/controller.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sqflite/sqflite.dart';

class AppConfig {
  String _topicType = "b1";

  String get topicType => _topicType;
  Future<int> notifyModeChange() async {
    var value = await AppController().getMode();
    if (value == _topicType) {
      return 0;
    }

    _topicType = value;
    switch (AppConfig().topicType) {
      case "b1":
        _mode = B1Mode();
        //_dbController = B1Database();
        break;
      case "b2":
        _mode = B2Mode();
        //_dbController = B2Database();
        break;
      default:
        throw UnimplementedError();
    }
    await _mode.ensureDB();
    return 1;
  }

  BaseMode _mode = B1Mode();
  BaseMode get mode => _mode;

  DBController _dbController = DBController();
  DBController get dbController => _dbController;
  Future<Database> openDB() => dbController.openDB();

  AppConfig._privateConstructor();

  Future<void> init() async {
    await notifyModeChange();
    return;
  }

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
}
