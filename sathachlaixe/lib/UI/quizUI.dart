import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/quiz.dart';
import '../SQLite/quizSQLite.dart';
import 'Test/result_screen.dart';

class QuizPage extends StatefulWidget {
  QuizPage(
      {Key? key,
      required this.title,
      required this.quizlist,
      required this.topicId,
      required this.timeLimit,
      this.history = null})
      : super(key: key) {
    timeEnd = DateTime.now().add(timeLimit);
  }

  QuizPage.fromHistory(
    HistoryModel history, {
    Key? key,
    required this.title,
    required this.quizlist,
  }) : super(key: key) {
    topicId = history.topicID;
    timeLimit = repository.getTimeLimit();
    timeEnd = DateTime.now().add(timeLimit);
    this.history = history;
  }

  final double txtSizeQues = 20.h;
  final double txtSizeAnswer = 16.h;

  final String title;
  final List<QuizBaseDB> quizlist;

  late final int topicId;
  late final Duration timeLimit;
  late final DateTime timeEnd;

  late final HistoryModel? history;

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
    if (widget.history != null && widget.history!.hasStarted) {
      _resume(widget.history as HistoryModel);
      return;
    }

    _timeLeft = Duration(seconds: widget.timeLimit.inSeconds);
    _currentQuesIndex = 0;
    _currentSelectedAnswerIndex = 0;
    _mode = 0;
    selectedAnswer = List.filled(widget.quizlist.length, 0);

    _startTimer();
  }

  void _resume(HistoryModel history) {
    _timeLeft = history.timeLeft;
    _currentQuesIndex = 0;
    selectedAnswer = List.of(history.selectedAns_int);
    _currentSelectedAnswerIndex = selectedAnswer[0];
    if (history.isFinished) {
      _mode = 1;
    } else {
      _mode = 0;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
        if (_timeLeft.isNegative) {
          _onPressSubmit(this.context);
        }
      },
    );
  }

  int _currentQuesIndex = 0;
  int _currentSelectedAnswerIndex = -1;
  int _mode = 0; // Mode 0 is test, 1 is review
  Duration _timeLeft = Duration(minutes: 30); // 30min
  Timer? _timer;
  late List selectedAnswer;

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  int _getCorrectIndex(int index) {
    return widget.quizlist[index].correct;
  }

  void _onPressBack(BuildContext context) {
    if (_mode == 1) {
      Navigator.pop(context, 'Review');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Tạm dừng"),
          content: const Text("Bạn có muốn tạm dừng để tiếp tục lần tới?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('Có'),
            ),
          ],
        ),
      ).then((value) {
        if (value == "Ok") {
          _onPressPause(context);
        } else if (value == "Cancel") {
          Navigator.pop(context, 'Cancel');
        }
      });
    }
  }

  void _onPressPause(context) {
    _saveHistory(false);
    Navigator.pop(context, 'Pause');
  }

  void _onPressAnswer(index) {
    setState(() {
      _currentSelectedAnswerIndex = index;
      selectedAnswer[_currentQuesIndex] = _currentSelectedAnswerIndex;
    });
  }

  void _onChangeQuizIndex(int index) {
    if (index > -1 && index < widget.quizlist.length) {
      setState(() {
        _currentQuesIndex = index;
        _currentSelectedAnswerIndex = selectedAnswer[_currentQuesIndex];
      });
    }
  }

  void _onPressNext() {
    _onChangeQuizIndex(_currentQuesIndex + 1);
  }

  void _onPressPrevious() {
    _onChangeQuizIndex(_currentQuesIndex - 1);
  }

  void _onPressSubmit(BuildContext context) {
    _timer!.cancel();
    var history = _saveHistory(true);
    QuizState quizState =
        QuizState(historyModel: history, listQuestion: widget.quizlist);
    var resultView = ResultTest(
      quizState: quizState,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => resultView))
        .then((value) {
      if (value == ResultTest.RESULT_CANCEL) {
<<<<<<< Updated upstream
        _onPressBack(context);
=======
        Navigator.pop(this.context, "Result");
>>>>>>> Stashed changes
      } else if (value == ResultTest.RESULT_REVIEW) {
        _changeToReviewMode();
      }
    });
  }

  HistoryModel _saveHistory(bool isFinished) {
    var history = HistoryModel(topicID: widget.topicId);
    history.selectedAns = List.generate(
        selectedAnswer.length, (index) => (selectedAnswer[index]).toString());
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

    return history;
  }

  void _changeToReviewMode() {
    setState(() {
      _mode = 1;
    });
  }

  Widget buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Row(
        children: <Widget>[
          ReturnButton.withCallback(
            callback: () => _onPressBack(context),
          ),
          SizedBox(
            width: 95.w,
          ),
          Text(
            widget.title,
            style: kText22Bold_13.copyWith(fontSize: 22.h),
          ),
        ],
      ),
    );
  }

  Widget getQuesNavigationIcon(int index) {
    String path = 'assets/icons/button_quiz_navi_normal.svg';
    if (_mode == 0) {
      if (selectedAnswer[index] > 0) {
        path = 'assets/icons/button_quiz_navi_selected.svg';
      }
    } else if (_mode == 1) {
      if (selectedAnswer[index] == _getCorrectIndex(index)) {
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
      onPressed: () => _onChangeQuizIndex(index),
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
                style: kText24Normal_13.copyWith(
                    fontSize: 24.h, color: Colors.white)),
            Text('/' + widget.quizlist.length.toString(),
                style: kText18Medium_13),
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
                    style: kText16Normal_13),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget buildAnswer(String content, int index) {
    var primecolor = dtcolor11;
    String iconPath = 'assets/icons/quiz_check_unselected.svg';

    if (_mode == 0) {
      if (_currentSelectedAnswerIndex == index) {
        // Selected
        primecolor = dtcolor1;
        iconPath = 'assets/icons/quiz_check_selected.svg';
      }
    } else if (_mode == 1) {
      if (_getCorrectIndex(_currentQuesIndex) == index) {
        // Correct
        primecolor = dtcolor5;
      }
      if (selectedAnswer[_currentQuesIndex] == index) {
        if (_getCorrectIndex(_currentQuesIndex) != index) {
          // Wrong
          primecolor = dtcolor4;
          iconPath = 'assets/icons/quiz_check_wrong.svg';
        } else {
          // Correct
          primecolor = dtcolor5;
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
        onTap: () => _onPressAnswer(index),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: SvgPicture.asset(iconPath)),
            Expanded(
              child: Text(
                content,
                style: kText16Normal_14.copyWith(
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
    var answers = List<Widget>.generate(quiz.answers.length,
        (index) => buildAnswer(quiz.answers[index], index + 1),
        growable: true);
    if (quiz.imageurl.length > 1) {
      answers.insert(
          0,
          Image.network(
            quiz.imageurl,
            errorBuilder: (c, o, s) {
              return const Text(
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
                style: kText16Normal_13.copyWith(
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
                    onPressed: _onPressPrevious,
                    iconSize: 50.h,
                    icon: SvgPicture.asset('assets/icons/previousButton.svg')),
                GestureDetector(
                  child: Container(
                    height: 50.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      color: dtcolor1,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _mode == 0 ? "Nộp bài" : "Trở về",
                      style: kText22Bold_13,
                    ),
                  ),
                  onTap: () {
                    _mode == 0
                        ? _onPressSubmit(context)
                        : _onPressBack(context);
                  },
                ),
                IconButton(
                    onPressed: _onPressNext,
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
    return SafeArea(
        child: Stack(
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
    ));
  }
}
