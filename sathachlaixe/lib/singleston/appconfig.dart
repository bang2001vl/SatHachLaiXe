import 'package:sathachlaixe/repository/mode/b1.dart';
import 'package:sathachlaixe/repository/mode/b2.dart';
import 'package:sathachlaixe/repository/mode/base.dart';
import 'package:sathachlaixe/repository/sqlite/controller.dart';

class AppConfig {
  String _topicType = "b1";

  String get topicType => _topicType;
  set topicType(value) {
    _topicType = value;
    switch (AppConfig().topicType) {
      case "b1":
        _mode = B1Mode();
        break;
      case "b2":
        _mode = B2Mode();
        break;
      default:
        _mode = B1Mode();
        break;
    }
    _dbController.changeMode(_topicType);
  }

  BaseMode _mode = B1Mode();
  BaseMode get mode => _mode;

  DBController _dbController = DBController();
  DBController get dbController => _dbController;

  AppConfig._privateConstructor() {}

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
}
