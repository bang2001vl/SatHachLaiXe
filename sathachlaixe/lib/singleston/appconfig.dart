import 'dart:developer';

import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/model/auth.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/repository/mode/b1.dart';
import 'package:sathachlaixe/repository/mode/b2.dart';
import 'package:sathachlaixe/repository/mode/base.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/repository/sqlite/controller.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AppConfig {
  static final String _keySyncState = "syncState";
  static final String _keyToken = "token";
  static final String _keyUserDisplayName = "name";
  static final String _keyMode = "mode";

  int? syncState;
  UserModel? userInfo;
  String? token;
  String _topicType = "b1";

  /* Preferences state */
  Future<void> setSycnState(int? state) async {
    var prefs = await SharedPreferences.getInstance();
    if (state == null) {
      prefs.remove(_keySyncState);
    } else
      prefs.setInt(_keySyncState, state);
  }

  Future<int?> getSycnState() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySyncState);
  }

/* Preferences mode */
  Future<void> setMode(String? mode) async {
    var prefs = await SharedPreferences.getInstance();
    if (mode == null) {
      prefs.remove(_keyMode);
    } else
      prefs.setString(_keyMode, mode);
  }

  Future<String?> getMode() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMode);
  }

/* Preferences user's info */
  Future<void> saveUserInfo(UserModel? user) async {
    var prefs = await SharedPreferences.getInstance();
    if (user == null) {
      prefs.remove(_keyUserDisplayName);
    } else {
      prefs.setString(_keyUserDisplayName, user!.name);
    }
  }

  Future<UserModel?> getSavedUser() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyUserDisplayName)) {
      return null;
    }

    return UserModel(
      name: _keyUserDisplayName,
    );
  }

  /* Preferences token*/
  Future<void> saveToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();
    if (token == null) {
      prefs.remove(_keyToken);
    } else {
      prefs.setString(_keyToken, token);
    }
  }

  Future<String?> getSavedToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  String get topicType => _topicType;
  Future<int> notifyModeChange() async {
    var value = await this.getMode();
    if (value == _topicType) {
      return 0;
    }

    _topicType = value!;
    switch (AppConfig().topicType) {
      case "b1":
        _mode = B1Mode();
        break;
      case "b2":
        _mode = B2Mode();
        break;
      default:
        throw UnimplementedError();
    }
    // Reload mode's database
    await _mode.ensureDB();
    return 1;
  }

  BaseMode _mode = B1Mode();
  BaseMode get mode => _mode;

  DBController _dbController = DBController();
  DBController get dbController => _dbController;
  Future<Database> openDB() => dbController.openDB();

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyMode)) {
      log("First time run app");
      await _mode.ensureDB();
      await AppDBController().openDB();
      await setMode("b1");
      _topicType = "b1";
    }

    // Load all preferences
    this.syncState = await getSycnState();
    this.token = await getSavedToken();
    this.userInfo = await getSavedUser();

    // SocketController.instance.init();
    // return;
    // if (syncState == 1) {
    //   SocketController.instance.init();
    // }
  }

  /* Singleton block */
  AppConfig._privateConstructor();
  static final AppConfig _instance = AppConfig._privateConstructor();
  static AppConfig get instance => _instance;

  factory AppConfig() {
    return _instance;
  }
}
