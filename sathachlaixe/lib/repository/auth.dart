import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sathachlaixe/UI/Login/login_screen.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/auth.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends AuthRepo {
  final Dio dio = Dio(BaseOptions(connectTimeout: 2000, receiveTimeout: 2000));
  final String _apiURL = RepositoryGL.serverURL + ":8080/auth";

  String makeURL(String apiName) {
    return _apiURL + "/" + apiName;
  }

  @override
  FutureOr<int> login(String email, String password,
      {bool needSaveAuth = true, bool isAutoLogin = false}) async {
    log("Login with isAutoLogin = " + isAutoLogin.toString());
    var url = this.makeURL("login");
    var headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    var auth = AuthModel(
      email: email,
      // password: isAutoLogin ? password : _encryptPassword(password),
      password: password, // Test-only
    );
    try {
      var res = await dio.post(
        url,
        options: Options(headers: headers),
        data: auth.toJSON(),
      );

      if (res.data["errorCode"] != null) {
        var errorCode = res.data["errorCode"] as int;
        return -1 * errorCode;
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
      if (needSaveAuth) {
        await repository.auth.saveAuth(auth);
      }
      await onLoginSuccess(userInfo, token, isAutoLogin);
      return 1;
    } on DioError catch (err) {
      log("APIs: Login falied with error");
      if (err.type == DioErrorType.connectTimeout) {
        log("Connect time out");
      }
      //notifyConnectionError();
      return -1;
    }
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
  FutureOr<int> login(String email, String password,
      {bool needSaveAuth = true, bool isAutoLogin = false});

  Future<int> logout({bool needComfirm = true}) async {
    log("Auth: Logout");
    if (needComfirm) {
      var result = await showYesNoDialog("Đăng xuất",
          "Bạn sẽ đăng xuất tài khoản khỏi thiết bị này", "Hủy", "Đăng xuất");
      if (result == 1) {
        return -1;
      }
    }

    var h = await repository.getUnsyncHistories();
    var p = await repository.getUnsyncPractices();

    if (needComfirm && (h.length > 0 || p.length > 0)) {
      var result = await showYesNoDialog(
          "Chưa đồng bộ", "Dữ liệu chưa đồng bộ sẽ bị mất", "Tiếp tục", "Hủy");
      if (result == 2) {
        return -1;
      }
    }

    if (repository.isAuthorized) {
      var token = AppConfig.instance.token as String;
      await SocketController.instance.close();
    }

    await repository.deleteAllLocalData();
    await repository.updateToken(null);
    await repository.updateSyncState(null);

    await saveAuth(null);

    await repository.updateUserInfo(null);
    SocketBinding.instance.invokeOnUserInfoChanged();

    return 1;
  }

  Future<int> register(String token);

  Future<void> onLoginSuccess(
      UserModel userInfo, String token, bool isAutoLogin) async {
    log("APIs: Login success");
    var h = await repository.getUnsyncHistories();
    var p = await repository.getUnsyncPractices();

    if (!isAutoLogin && (h.length > 0 || p.length > 0)) {
      var rs = await askBeforeSync();
      if (rs == "Delete") {
        await repository.deleteAllLocalData();
      }
    }

    if (!isAutoLogin) {
      await repository.updateLatestSyncTime(0);
      await repository.updateSyncState(1, needLogin: false);
    }

    await repository.updateUserInfo(userInfo);
    log("Token = " + token);
    await repository.updateToken(token);

    SocketController.instance.init();
    SocketBinding.instance.invokeOnUserInfoChanged();
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

  Future<String?> showLogin(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    ).then((value) {
      return value;
    });
  }

  Future<int> autoLogin({bool askFix = false}) async {
    log("Auth: Auto login");
    var authSaved = await getAuth();
    if (authSaved != null) {
      var rs =
          await login(authSaved.email, authSaved.password, isAutoLogin: true);
      if (rs == 1) {
        log("Auth: Auto login success");
        return 1;
      } else {
        log("Auth: Auto login failed with code = " + rs.toString());
        return rs;
      }
    }
    return -2;
  }

  void onUnauthorized() async {
    log("Auth: Unauthorized");
    var authSaved = await getAuth();
    if (authSaved != null) {
      var rs =
          await login(authSaved.email, authSaved.password, isAutoLogin: true);
      if (rs == 1) {
        // Login success
        return;
      }
    }

    // Cannot auto login
    var context = getCurrentContext();
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          title: const Text("Đồng bộ thất bại"),
          content: const Text("Đã có lỗi xảy ra trong quá trình đăng nhập"),
          actions: [
            TextButton(
              child: const Text("Đăng nhập lại"),
              onPressed: () async {
                showLogin(context);
                Navigator.pop(context, "login");
              },
            ),
            TextButton(
              child: const Text("Đăng xuất"),
              onPressed: () async {
                await repository.auth.logout();
                Navigator.pop(context, "logout");
              },
            ),
          ],
        ),
      ),
    ).then((value) {
      if (value == "login") {
        showLogin(context);
      }
    });
  }

  static const _keyAuth = "auth";

  Future<void> saveAuth(AuthModel? auth) async {
    log("Save auth");
    var prefs = await SharedPreferences.getInstance();
    var key = AuthRepo._keyAuth;
    if (auth == null) {
      prefs.remove(key);
    } else {
      var json = jsonEncode(auth.toJSON());
      log(json);
      prefs.setString(key, json);
    }
  }

  Future<AuthModel?> getAuth() async {
    var prefs = await SharedPreferences.getInstance();
    var key = AuthRepo._keyAuth;
    if (prefs.containsKey(key)) {
      var json = prefs.getString(key);
      log(json!);
      return AuthModel.fromJSON(jsonDecode(json));
    } else {
      return null;
    }
  }

  Future<bool> hasSaveLogin() async {
    return await getAuth() != null;
  }

  Future<String?> getEmail() async {
    var auth = await getAuth();
    return auth == null ? null : auth.email;
  }
}
