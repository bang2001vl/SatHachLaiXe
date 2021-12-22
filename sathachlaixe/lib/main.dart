import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import './UI/quizUI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<QuizBaseDB>> getQuizList(List questionIDs) async {
    List<QuizBaseDB> quizs = List<QuizBaseDB>.empty(growable: true);
    var db = QuizDB();
    for (int i = 0; i < questionIDs.length; i++) {
      quizs.add(await db.findQuizById(questionIDs[i]));
    }
    return quizs;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log("Start init configuare");
    AppConfig().init().then((value) => log("End init configuare"));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: "My Home Page",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 896),
        builder: () {
          return MaterialApp(
            home: HomeScreen(),
          );
        });
  }
}
