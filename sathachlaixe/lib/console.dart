import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/quizUI.dart';
import 'package:sathachlaixe/singleston/repository.dart';

import 'model/history.dart';
import 'repository/sqlite/historyController.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 896),
        builder: () {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new MyHomePage(title: 'Flutter Hello World'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _test(BuildContext context) async {
    var l = await repository.getHistory();
    var rand = l[0];
    onPressTest(context, rand);
  }

  void onPressTest(BuildContext context, HistoryModel lastestHistory) {
    if (lastestHistory.isFinished) {
      beginQuiz(context, lastestHistory);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chưa hoàn thành"),
          content: const Text("Bạn có muốn tiếp tục lần thi trước?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: const Text('Làm lại'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 2),
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      ).then((value) {
        if (value == 1) {
          beginQuiz(context, lastestHistory);
        } else if (value == 2) {
          resumeQuiz(context, lastestHistory);
        }
      });
    }
  }

  void resumeQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QuizPage.fromHistory(history,
              title: "Đề " + history.topicID.toString(), quizlist: quizlist);
        },
      ),
    );
  }

  void beginQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QuizPage(
            title: history.topicID == 0
                ? "Đề ngẫu nhiên"
                : "Đề " + history.topicID.toString(),
            quizlist: quizlist,
            topicId: history.topicID,
            timeLimit: repository.getTimeLimit(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '0',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _test(context),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
