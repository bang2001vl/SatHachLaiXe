import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import './UI/quizUI.dart';
import 'package:sathachlaixe/UI/Login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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

  Widget startQuiz(List quizIds) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return FutureBuilder(
      future: getQuizList(quizIds),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) {
          var data = s.data! as List<QuizBaseDB>;
          debugPrint('length = ' + data.length.toString());
          return QuizPage(
            title: 'Flutter Demo Home Page',
            quizlist: data,
          );
        }

        return Column(children: const [
          Center(
            child: const CircularProgressIndicator(),
          ),
        ]);
      },
    );
  }

  Widget test() {
    QuizDB db = new QuizDB();
    return FutureBuilder(
      future: db.ensureDB(),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) {
          return startQuiz(List.generate(30, (index) => index + 3));
        }

        return Column(children: const [
          Center(
            child: const CircularProgressIndicator(),
          ),
        ]);
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<QuizBaseDB>> getQuizList(List questionIDs) async {
    List<QuizBaseDB> quizs = List<QuizBaseDB>.empty(growable: true);
    var db = QuizDB();
    for (int i = 0; i < questionIDs.length; i++) {
      quizs.add(await db.findQuizById(questionIDs[i]));
    }
    return quizs;
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ScreenUtilInit(
                    designSize: Size(414, 896),
                    builder: () {
                      return MaterialApp(
                        home: LoginScreen(),
                      );
                    });

                return HomeScreen();
              },
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
