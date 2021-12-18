import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import '../SQLite/quizSQLite.dart';

class QuizPage extends StatefulWidget {
  QuizPage({
    Key? key,
    required this.title,
    required this.quizlist,
    required this.topicId,
    required this.timeLimit,
  }) : super(key: key) {
    timeEnd = DateTime.now().add(timeLimit);
  }

  final String title;
  final int topicId;
  final List<QuizBaseDB> quizlist;

  final double txtSizeQues = 20.h;
  final double txtSizeAnswer = 16.h;

  final Duration timeLimit;

  late final DateTime timeEnd;

  @override
  _QuizPageState createState() {
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  _QuizPageState() : super() {}

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _timeLeft = Duration(seconds: widget.timeLimit.inSeconds);
    _currentQuesIndex = 0;
    _currentSelectedAnswerIndex = -1;
    _mode = 0;

    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
        if (_timeLeft.isNegative) {
          _timer.cancel();
          onPressSubmit();
        }
      },
    );
    selectedAnswer = List.filled(widget.quizlist.length, -1);
  }

  int _currentQuesIndex = 0;
  int _currentSelectedAnswerIndex = -1;
  int _mode = 0; // Mode 0 is test, 1 is review
  Duration _timeLeft = Duration(minutes: 30); // 30min
  late Timer _timer;
  late List selectedAnswer = List.filled(widget.quizlist.length, -1);

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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

  HistoryModel _saveHistory(bool isFinished) {
    var history = HistoryModel(topicID: widget.topicId);
    history.selectedAns = List.generate(selectedAnswer.length,
        (index) => (selectedAnswer[index] + 1).toString());
    history.correctAns = List.generate(widget.quizlist.length,
        (index) => widget.quizlist[index].correct.toString());
    history.questionIds = List.generate(widget.quizlist.length,
        (index) => widget.quizlist[index].id.toString());

    history.timeLeft = _timeLeft;
    history.isFinished = isFinished;
    if (history.isFinished) {
      history.isPassed = repository.checkPassed(history);
    }

    repository.insertHistory(history);

    //test();

    return history;
  }

  void test() async {
    var temp = await repository.getHistory();
    var temp2 = await repository.getAllFinishedHistory();
  }

  void changeToReviewMode() {
    setState(() {
      _mode = 1;
    });
  }

  void onPressSubmit() {
    _timer.cancel();
    var history = _saveHistory(true);
    if (history.isPassed) {
      // Navigate to success view
    } else {
      // Navigate to failed view
    }
  }

  void onPressPause(context) {
    _saveHistory(false);
    Navigator.pop(context);
  }

  void onPressAnswer(index) {
    setState(() {
      _currentSelectedAnswerIndex = index;
      selectedAnswer[_currentQuesIndex] = _currentSelectedAnswerIndex;
    });
  }

  void changeCurrentIndex(int index) {
    if (index > -1 && index < widget.quizlist.length) {
      setState(() {
        //selectedAnswer[_currentQuesIndex] = _currentSelectedAnswerIndex;
        _currentQuesIndex = index;
        _currentSelectedAnswerIndex = selectedAnswer[_currentQuesIndex];
      });
    }
  }

  Widget buildTopBar() {
    String getIconPath(String name) {
      return 'assets/icons/' + name;
    }

    String pathToIcons = 'assets/icons/';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Row(
        children: <Widget>[
          ReturnButton(),
          SizedBox(
            width: 95.w,
          ),
          Text(
            widget.title,
            style: buttonText.copyWith(fontSize: 22.h),
          ),
        ],
      ),
    );
  }

  Widget getQuesNavigationIcon(int index) {
    String path = 'assets/icons/button_quiz_navi_normal.svg';
    if (_mode == 0) {
      if (selectedAnswer[index] != -1) {
        path = 'assets/icons/button_quiz_navi_selected.svg';
      }
    } else if (_mode == 1) {
      if (selectedAnswer[index] == getCorrectIndex(index)) {
        path = 'assets/icons/button_quiz_navi_correct.svg';
      } else {
        path = 'assets/icons/button_quiz_navi_wrong.svg';
      }
    }

    return IconButton(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      icon: SvgPicture.asset(path),
      iconSize: 25.h,
      constraints: BoxConstraints(minHeight: 16.h, minWidth: 16.w),
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
                style: textfieldStyle.copyWith(
                    fontSize: 24.h, color: Colors.white)),
            Text('/' + widget.quizlist.length.toString(),
                style: textfieldStyle.copyWith(
                    fontSize: 18.h,
                    color: Colors.white,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/icons/quiz_clock_bg.svg'),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/icons/ic_clock.svg'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  _timeLeft.inMinutes.toString().padLeft(2, '0') +
                      ':' +
                      _timeLeft.inSeconds
                          .remainder(60)
                          .toString()
                          .padLeft(2, '0'),
                  style: textfieldStyle.copyWith(
                      fontSize: 16.h, color: Colors.white),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget buildAnswer(String content, int index) {
    var primecolor = defaultAnsColor;
    String iconPath = 'assets/icons/quiz_check_unselected.svg';

    if (_mode == 0) {
      if (_currentSelectedAnswerIndex == index) {
        // Selected
        primecolor = mainColor;
        iconPath = 'assets/icons/quiz_check_selected.svg';
      }
    } else if (_mode == 1) {
      if (getCorrectIndex(_currentQuesIndex) == index) {
        // Correct
        primecolor = correctAnsColor;
      }
      if (selectedAnswer[_currentQuesIndex] == index) {
        if (getCorrectIndex(_currentQuesIndex) != index) {
          // Wrong
          primecolor = wrongAnsColor;
          iconPath = 'assets/icons/quiz_check_wrong.svg';
        } else {
          // Correct
          primecolor = correctAnsColor;
          iconPath = 'assets/icons/quiz_check_correct.svg';
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 5.h, left: 10, right: 10, bottom: 5.h),
      padding: EdgeInsets.all(5),
      constraints: BoxConstraints(minHeight: 45),
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
            SizedBox(width: 40, child: SvgPicture.asset(iconPath)),
            Expanded(
              child: Text(
                content,
                style: textfieldStyle.copyWith(
                    color: primecolor, fontSize: widget.txtSizeAnswer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(QuizBaseDB quiz) {
    var quiz = widget.quizlist[_currentQuesIndex];
    var answers = List<Widget>.generate(
        quiz.answers.length, (index) => buildAnswer(quiz.answers[index], index),
        growable: true);
    if (quiz.imageurl != null && quiz.imageurl.length > 1) {
      answers.insert(
          0,
          Image.network(
            quiz.imageurl,
            errorBuilder: (c, o, s) {
              return Text(
                'Không tìm thấy ảnh',
                style: TextStyle(color: Colors.red),
              );
            },
          ));
    }
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
              margin: EdgeInsets.only(
                  top: 10.h, bottom: 20.h, left: 10.w, right: 10.w),
              child: Text(
                quiz.question,
                style: textfieldStyle.copyWith(
                  color: Colors.black,
                  fontSize: 20.h,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: answers,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: onPressPrevious,
                    iconSize: 50.h,
                    icon: SvgPicture.asset('assets/icons/previousButton.svg')),
                GestureDetector(
                    child: Container(
                      height: 50.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: mainColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'NỘP BÀI',
                        style: buttonText,
                      ),
                    ),
                    onTap: onPressSubmit),
                IconButton(
                    onPressed: onPressNext,
                    iconSize: 50.h,
                    icon: SvgPicture.asset('assets/icons/nextButton.svg')),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  margin: EdgeInsets.only(left: 25.w, right: 25.w),
                  constraints: BoxConstraints(minHeight: 120.h),
                  child: buildQuesNavigation(),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25.w, right: 15.w),
                  constraints: BoxConstraints(minHeight: 50.h),
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
