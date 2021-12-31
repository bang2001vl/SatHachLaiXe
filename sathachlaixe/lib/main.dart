import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/helper/widgetObserver.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> loadConfiguare() async {
    log("Start init configuare");
    // Check DB
    await QuizDB().ensureDB();
    log("End init configuare");
    return true;
  }

  void onInitApp() {
    AppConfig().init();
  }

  void onPaused() {
    AppConfig.instance.savePrefs();
    if (repository.isSyncON) {
      SocketController.instance.notifyDataChanged();
    }
  }

  void onResume() {
    AppConfig.instance.loadPreferences();
    if (repository.isSyncON) {
      SocketController.instance.getUnsyncData();
    }
  }

  void onDisposeApp() {
    SocketController().close();
    AppConfig().dbController.closeDB();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WidgetObserver(
      onInit: () => onInitApp(),
      onDispose: () => onDisposeApp(),
      child: ScreenUtilInit(
          designSize: Size(414, 896),
          builder: () {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              home: FutureBuilder(
                  future: loadConfiguare(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return HomeScreen();
                    }
                    if (snapshot.hasError) {
                      return buildError(context, snapshot.error);
                    }
                    return Scaffold(
                      body: buildLoading(context),
                    );
                  }),
            );
          }),
    );
  }
}
