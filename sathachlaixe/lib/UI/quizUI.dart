import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../SQLite/quizSQLite.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key? key, required this.title, required this.quizlist, this.timeLimit = const Duration(minutes: 30)})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<QuizBaseDB> quizlist;

  final double txtSizeQues = 20;
  final double txtSizeAnswer = 18;

  final Duration timeLimit;

  late DateTime timeEnd;

  @override
  _QuizPageState createState() {
    timeEnd = DateTime.now().add(timeLimit);
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  _QuizPageState() : super() {
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          _timeLeft = widget.timeEnd.difference(DateTime.now());
        });
        if (_timeLeft.isNegative) {
          _timer.cancel();
          onPressSubmit();
        }
      },
    );
  }

  int _currentQuesIndex = 0;
  int _currentSelectedAnswerIndex = -1;
  int _mode = 0; // Mode 0 is test, 1 is review
  Duration _timeLeft = Duration(minutes: 30); // 30min
  late Timer _timer;

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timer.cancel();
    super.dispose();
  }

  late List selectedAnswer = List.filled(widget.quizlist.length, -1);

  int getCorrectIndex(int index) {
    return widget.quizlist[index].correct - 1;
  }

  void onPressBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressNext() {
    changeCurrentIndex(_currentQuesIndex + 1);
  }

  void onPressPrevious() {
    changeCurrentIndex(_currentQuesIndex - 1);
  }

  void onPressSubmit() {
    setState(() {
      _mode = 1;
    });
  }

  void onPressAnswer(index) {
    setState(() {
      _currentSelectedAnswerIndex = index;
    });
  }

  void changeCurrentIndex(int index) {
    if (index > -1 && index < widget.quizlist.length) {
      setState(() {
        selectedAnswer[_currentQuesIndex] = _currentSelectedAnswerIndex;
        _currentQuesIndex = index;
        _currentSelectedAnswerIndex = selectedAnswer[_currentQuesIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTopBar() {
      String getIconPath(String name) {
        return 'assets/icons/' + name;
      }

      String pathToIcons = 'assets/icons/';
      return Row(
        children: [
          IconButton(
            onPressed: () {
              onPressBack(context);
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/icons/ButtonBack.png'),
                Image.asset('assets/icons/arrow_back.png'),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: Text(widget.title, style: TextStyle(fontSize: 20)),
          ))
        ],
      );
    }

    Widget getQuesNavigationIcon(int index) {
      String path = 'assets/icons/button_quiz_navi_normal.png';
      if (_mode == 0) {
        if (selectedAnswer[index] != -1) {
          path = 'assets/icons/button_quiz_navi_selected.png';
        }
      } else if (_mode == 1) {
        if (selectedAnswer[index] == getCorrectIndex(index)) {
          path = 'assets/icons/button_quiz_navi_correct.png';
        } else {
          path = 'assets/icons/button_quiz_navi_wrong.png';
        }
      }

      return IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        icon: Image.asset(path),
        iconSize: 25,
        constraints: BoxConstraints(minHeight: 16, minWidth: 16),
        onPressed: () => changeCurrentIndex(index),
      );
    }

    Widget buildQuesNavigation() {
      var firstLine = new List<Widget>.empty(growable: true);
      for (int i = 0; i < widget.quizlist.length && i < 10; i++) {
        firstLine.add(getQuesNavigationIcon(i));
      }
      var secondLine = new List<Widget>.empty(growable: true);
      for (int i = 10; i < widget.quizlist.length && i < 20; i++) {
        secondLine.add(getQuesNavigationIcon(i));
      }
      var thirdLine = new List<Widget>.empty(growable: true);
      for (int i = 20; i < widget.quizlist.length && i < 30; i++) {
        thirdLine.add(getQuesNavigationIcon(i));
      }
      var fourLine = new List<Widget>.empty(growable: true);
      for (int i = 30; i < widget.quizlist.length && i < 40; i++) {
        fourLine.add(getQuesNavigationIcon(i));
      }

      Row row(List<Widget> icons) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: icons,
          );

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          row(firstLine),
          row(secondLine),
          row(thirdLine),
          row(fourLine),
        ],
      );
    }

    Widget buildQuizTitleBar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Câu ' + (_currentQuesIndex + 1).toString(),
                  style: TextStyle(fontSize: 18)),
              Text('/' + widget.quizlist.length.toString()),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/icons/quiz_clock_bg.png'),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/icons/ic_clock.png'),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _timeLeft.inMinutes.toString().padLeft(2,'0') +
                        ':' +
                        _timeLeft.inSeconds.remainder(60).toString().padLeft(2,'0'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    }

    Widget buildAnswer(String content, int index) {
      var primecolor = Colors.black;
      String iconPath = 'assets/icons/quiz_check_unselected.png';

      if (_mode == 0) {
        if (_currentSelectedAnswerIndex == index) {
          // Selected
          primecolor = Colors.blue;
          iconPath = 'assets/icons/quiz_check_selected.png';
        }
      } else if (_mode == 1) {
        if (getCorrectIndex(_currentQuesIndex) == index) {
          // Correct
          primecolor = Colors.green;
        }
        if (selectedAnswer[_currentQuesIndex] == index) {
          if (getCorrectIndex(_currentQuesIndex) != index) {
            // Wrong
            primecolor = Colors.red;
            iconPath = 'assets/icons/quiz_check_wrong.png';
          } else {
            // Correct
            primecolor = Colors.green;
            iconPath = 'assets/icons/quiz_check_correct.png';
          }
        }
      }

      return Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
            border: Border.all(
              color: primecolor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: () => onPressAnswer(index),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 40, child: Image.asset(iconPath)),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                      color: primecolor, fontSize: widget.txtSizeAnswer),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildQuestion(QuizBaseDB quiz) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.all(7),
                child: Text(
                  quiz.question,
                  style: TextStyle(
                      fontSize: widget.txtSizeQues,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List<Widget>.generate(quiz.answers.length,
                      (index) => buildAnswer(quiz.answers[index], index)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: onPressPrevious,
                      icon: Image.asset(
                          'assets/icons/quiz_btn_navi_bottom_left.png')),
                  SizedBox(
                    width: 200,
                    child: IconButton(
                      onPressed: onPressSubmit,
                      icon: Container(
                        alignment: AlignmentDirectional.center,
                        constraints: BoxConstraints(minWidth: 160),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text('NỘP BÀI',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: onPressNext,
                      icon: Image.asset(
                          'assets/icons/quiz_btn_navi_bottom_right.png')),
                ],
              )
            ],
          ),
        ),
      );
    }

    /*FutureBuilder<QuizBaseDB>(
      future: db.findQuizById(_currentQuesIndex),
      builder: (contextFB, snapshotFB) {
        if (snapshotFB.hasData) {
          if (snapshotFB.data == null)
            return Text("Has error: Data is null");
          QuizBaseDB quiz = snapshotFB.data!;
          correctAnswer[_currentQuesIndex] = quiz.correct;
          return buildQuestion(quiz);
        } else if (snapshotFB.hasError)
          return Text(
              "Has error: " + snapshotFB.error.toString());

        return Column(children: const [
          Center(
            child: const CircularProgressIndicator(),
          ),
        ]);
      },
    )*/

    return Stack(
      children: [
        Image.asset('assets/icons/blue_bg.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                buildTopBar(),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  constraints: BoxConstraints(minHeight: 120),
                  child: buildQuesNavigation(),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 15),
                  constraints: BoxConstraints(minHeight: 50),
                  child: buildQuizTitleBar(),
                ),
                Expanded(
                  child: buildQuestion(widget.quizlist[_currentQuesIndex]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
