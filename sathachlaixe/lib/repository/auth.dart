import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:js';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sathachlaixe/UI/Login/login_screen.dart';
import 'package:sathachlaixe/console.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/auth.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends AuthRepo {
  static final String _apiURL = "http://192.168.1.110:8080/auth";

  String makeURL(String apiName) {
    return _apiURL + "/" + apiName;
  }

  @override
  Future<int> login(String email, String password,
      {bool needSaveToken = true}) {
    var url = this.makeURL("login");
    var headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    var auth = AuthModel(
      email: email,
      password: _encryptPassword(password),
    );
    return Dio()
        .post(
      url,
      options: Options(headers: headers),
      data: auth.toJSON(),
    )
        .then((res) async {
      if (res.data["errorCode"] != null) {
        onError(res.data);
      }

      // Check respone
      var token = res.data["token"];
      var userJson = res.data["userInfo"];
      if (token == null || userJson == null) {
        log("APIs: Unknown server's response");
        log(res.data.toString());
        return -1;
      }

      // Success
      var userInfo = UserModel.fromJSON(userJson);
      onLoginSuccess(userInfo, token, needSaveToken);
      return 1;
    }).catchError(onError);
  }

  @override
  Future<int> logout(String token) {
    var url = this.makeURL("logout");
    var headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    return Dio()
        .post(
      url,
      options: Options(headers: headers),
    )
        .then((res) async {
      if (res.data["errorCode"] != null) {
        onError(res.data);
      }

      // Success
      log("APIs: Logout");
      log(res.data.toString());

      AppConfig.instance.syncState = null;
      AppConfig.instance.userInfo = null;
      AppConfig.instance.token = null;

      await AppConfig.instance.setSycnState(null);
      await AppConfig.instance.saveToken(null);
      await AppConfig.instance.saveUserInfo(null);

      await repository.deleteAllData();
      return 1;
    }).catchError(onError);
  }

  @override
  Future<int> register(String token) {
    // TODO: implement register
    throw UnimplementedError();
  }

  int onError(err) {
    log("APIs: Login falied with error");
    log(err.toString());
    return -1;
  }
}

abstract class AuthRepo {
  /// Send login data to server
  ///
  /// Return 1 if login successfull
  Future<int> login(String email, String password, {bool needSaveToken = true});

  Future<int> logout(String token);

  Future<int> register(String token);

  Future<void> onLoginSuccess(
      UserModel userInfo, String token, bool needSaveToken) async {
    var rs = await askBeforeSync();
    if (rs == "Delete") {
      await repository.deleteAllData();
    }

    AppConfig.instance.userInfo = userInfo;
    AppConfig.instance.token = token;
    AppConfig.instance.syncState = 1;

    await AppConfig.instance.saveUserInfo(userInfo);
    await AppConfig.instance.setSycnState(1);
    if (needSaveToken) {
      await AppConfig.instance.saveToken(token);
    }

    SocketController.instance.init();
  }

  Future<String?> askBeforeSync() {
    return showDialog<String>(
        context: getCurrentContext(),
        builder: (context) => AlertDialog(
              title: const Text("Lựa chọn đồng bộ"),
              content: const Text(
                  "Bạn có muốn giữ lại dữ liệu làm bài hiện tại và đồng bộ lên server?"),
              actions: [
                TextButton(
                  child: const Text("Có"),
                  onPressed: () => Navigator.pop(context, "OK"),
                ),
                TextButton(
                  child: const Text("Không"),
                  onPressed: () => Navigator.pop(context, "Delete"),
                ),
              ],
            ));
  }

  String _encryptPassword(String password) {
    var pass = sha512.convert(utf8.encode(password));
    return base64Encode(pass.bytes);
  }

  void showLogin(context) {
    // Maybe check auto login here

    // If can't auto login then go here
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void onUnauthorized() {
    var context = getCurrentContext();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đồng bộ thất bại"),
        content: const Text("Đã có lỗi xảy ra trong quá trình đăng nhập"),
        actions: [
          TextButton(
            child: const Text("Đăng nhập lại"),
            onPressed: () => Navigator.pop(context, "login"),
          ),
          TextButton(
            child: const Text("Tắt đồng bộ"),
            onPressed: () => Navigator.pop(context, "offSync"),
          ),
        ],
      ),
    ).then((value) {
      if (value == "login") {
        showLogin(context);
      } else if (value == "offSync") {
        AppConfig.instance.setSycnState(0);
      }
    });
  }
}
