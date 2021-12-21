import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Test/result_screen.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/bloc/quizBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/quiz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizPageWithBloc extends StatelessWidget {
  final TopicModel topic;
  late final HistoryModel? history;
  final int mode;
  QuizPageWithBloc(
      {required this.topic,
      required this.history,
      required this.mode,
      Key? key})
      : super(key: key);
  QuizPageWithBloc.modeStart({required this.topic, this.mode = 0, Key? key})
      : super(key: key);
  QuizPageWithBloc.modeReview(
      {required this.topic, required this.history, this.mode = 1, Key? key})
      : super(key: key);
  QuizPageWithBloc.modeResume(
      {required this.topic, required this.history, this.mode = 2, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Build at QuizPageWithBloc");
    var state;
    String title =
        topic.isRandom ? "Đề ngẫu nhiên" : "Đề số " + topic.topicId.toString();
    if (mode == 0) {
      state = QuizState.fromTopic(topic);
    } else if (mode == 1) {
      state = QuizState.fromHistory(topic, history as HistoryModel);
    } else if (mode == 2) {
      state = QuizState(
        mode: 2,
        topic: this.topic,
        history: this.history as HistoryModel,
      );
    }
    return BlocProvider(
      create: (_) => QuizBloc(state),
      child: QuizPage(
        title: title,
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  final String title;
  QuizPage({Key? key, this.title = ""}) : super(key: key);

  void _onPressBack(BuildContext context, QuizState state) {
    if (state.mode == 1 || state.history.isFinished) {
      Navigator.pop(context, 'Cancel');
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
          _onPressPause(context, state);
        } else if (value == "Cancel") {
          Navigator.pop(context, 'Cancel');
        }
      });
    }
  }

  void _onPressPause(BuildContext context, QuizState state) {
    _saveHistory(false, state);
    Navigator.pop(context, 'Pause');
  }

  void _onSelectAnswer(BuildContext context, int select, int correct) {
    BlocProvider.of<QuizBloc>(context).selectAnswer(select, correct);
  }

  void _onChangeNavigation(BuildContext context, int index) {
    log("navigation to " + index.toString());
    BlocProvider.of<QuizBloc>(context).selectQuestion(index);
  }

  void _onPressNext(BuildContext context) {
    BlocProvider.of<QuizBloc>(context).selectQuestionNext();
  }

  void _onPressPrevious(BuildContext context) {
    BlocProvider.of<QuizBloc>(context).selectQuestionPrevious();
  }

  void _onPressSubmit(BuildContext context, QuizState state) {
    BlocProvider.of<QuizBloc>(context).stopTimer();
    if (state.history.selectedAns.contains("0")) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chưa hoàn tất"),
          content:
              const Text("Vẫn còn câu để trống. Bạn chắc chắn muốn nộp bài?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Không'),
            ),
          ],
        ),
      ).then((value) {
        if (value == "Ok") {
          _submit(context, state);
        }
      });
    } else {
      _submit(context, state);
    }
  }

  void _submit(BuildContext context, QuizState state) {
    var history = _saveHistory(true, state);
    var resultView = ResultTest(
      history: history,
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => resultView))
        .then((value) {
      if (value == ResultTest.RESULT_CANCEL) {
        Navigator.pop(context, "Review");
      } else if (value == ResultTest.RESULT_REVIEW) {
        _changeToReviewMode(context);
      }
    });
  }

  HistoryModel _saveHistory(bool isFinished, QuizState state) {
    var history = state.history;
    history.isFinished = isFinished;
    if (history.isFinished) {
      history.isPassed = repository.checkPassed(history);
    }

    repository.insertHistory(history);

    return history;
  }

  void _changeToReviewMode(BuildContext context) {
    BlocProvider.of<QuizBloc>(context).changeMode(1);
  }

  @override
  Widget build(BuildContext context) {
    log("Build QuizPage");
    BlocProvider.of<QuizBloc>(context).begin();
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
                BlocBuilder<QuizBloc, QuizState>(
                  builder: buildTopBar,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 25.w,
                    right: 25.w,
                  ),
                  constraints: BoxConstraints(minHeight: 120.h),
                  child: BlocBuilder<QuizBloc, QuizState>(
                    buildWhen: (previous, current) =>
                        current.selectedAnswer != previous.selectedAnswer ||
                        current.currentIndex != previous.currentIndex ||
                        current.mode != previous.mode,
                    builder: (context, state) {
                      if (state.mode == 1) {
                        return QuizNavigationWidget.modeReview(
                          state.history.selectedAns_int,
                          state.history.correctAns_int,
                          onSelect: (i) => _onChangeNavigation(context, i),
                        );
                      } else {
                        return QuizNavigationWidget.modeStart(
                          state.history.selectedAns_int,
                          onSelect: (i) => _onChangeNavigation(context, i),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25.w, right: 15.w),
                  constraints: BoxConstraints(minHeight: 50.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<QuizBloc, QuizState>(
                        buildWhen: (previous, current) =>
                            current.currentIndex != previous.currentIndex,
                        builder: (context, state) => QuizTitle(
                          questionIndex: state.currentIndex,
                          count: state.length,
                        ),
                      ),
                      BlocBuilder<QuizBloc, QuizState>(
                        buildWhen: (previous, current) =>
                            current.timeLeft != previous.timeLeft,
                        builder: (context, state) => QuizClock(
                          state.timeLeft,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<QuizBloc, QuizState>(
                    buildWhen: (previous, current) =>
                        current.currentIndex != previous.currentIndex,
                    builder: (context, state) => buildQuestion(context, state),
                  ),
                ),
                SizedBox(
                  height: 55.h,
                  child: BlocBuilder<QuizBloc, QuizState>(
                    buildWhen: (previous, current) =>
                        current.mode != previous.mode,
                    builder: (context, state) => buildButtonBar(context, state),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget buildTopBar(BuildContext context, QuizState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Row(
        children: <Widget>[
          ReturnButton.withCallback(
            callback: () => _onPressBack(context, state),
          ),
          SizedBox(
            width: 95.w,
          ),
          Text(
            title,
            style: kText22Bold_13.copyWith(fontSize: 22.h),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(BuildContext context, QuizState state) {
    return FutureBuilder<QuestionModel?>(
        future: repository.getQuestion(state.currentQuestionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // Load OK
            var quesData = snapshot.data!;
            return BlocBuilder<QuizBloc, QuizState>(
              buildWhen: (prev, curr) =>
                  prev.selectedAnswer != curr.selectedAnswer ||
                  prev.mode != curr.mode,
              builder: (context, state) {
                if (state.mode == 0 || state.mode == 2) {
                  return QuestionWidget.modeStart(
                    quesData,
                    state.history.selectedAns_int[state.currentIndex],
                    onSelectAnswer: (select, correct) =>
                        _onSelectAnswer(context, select, correct),
                  );
                } else {
                  return QuestionWidget.modeReview(
                    quesData,
                    state.history.selectedAns_int[state.currentIndex],
                    onSelectAnswer: (select, correct) =>
                        _onSelectAnswer(context, select, correct),
                  );
                }
              },
            );
          }
          // Load error or data is null
          if (snapshot.hasError) {
            return buildError(context, snapshot.error!);
          }
          // Loading
          return buildLoading(context);
        });
  }

  Widget buildButtonBar(BuildContext context, QuizState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => _onPressPrevious(context),
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
              state.mode == 1 ? "XONG" : "NỘP BÀI",
              style: kText22Bold_13,
            ),
          ),
          onTap: () {
            if (state.mode == 1) {
              Navigator.pop(context, "Review");
            } else {
              _onPressSubmit(context, state);
            }
          },
        ),
        IconButton(
            onPressed: () => _onPressNext(context),
            iconSize: 50.h,
            icon: SvgPicture.asset('assets/icons/nextButton.svg')),
      ],
    );
  }
}

class QuizTitle extends StatelessWidget {
  final int questionIndex;
  final int count;

  QuizTitle({required this.questionIndex, required this.count, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Câu ' + (questionIndex + 1).toString(),
            style:
                kText24Normal_13.copyWith(fontSize: 24.h, color: Colors.white)),
        Text('/' + count.toString(), style: kText18Medium_13),
      ],
    );
  }
}

class QuizClock extends StatelessWidget {
  final Duration timeLeft;
  QuizClock(this.timeLeft, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                timeLeft.inMinutes.toString().padLeft(2, '0') +
                    ':' +
                    timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'),
                style: kText16Normal_13),
          ],
        ),
      ],
    );
  }
}

class QuestionWidgetState {
  int questionId;
  int selectedAnswer;
  int mode;
  QuestionWidgetState({
    required this.questionId,
    required this.selectedAnswer,
    required this.mode,
  });
}

class QuestionWidget extends StatelessWidget {
  final QuestionModel questionData;
  final int _selectedAnswer;
  final int mode;
  final Function(int select, int correct)? onSelectAnswer;
  int get _correctAnswer => questionData.correct;
  QuestionWidget(this.questionData, this._selectedAnswer, this.mode,
      {Key? key, this.onSelectAnswer})
      : super(key: key);

  QuestionWidget.modeStart(this.questionData, this._selectedAnswer,
      {Key? key, this.onSelectAnswer, this.mode = 0})
      : super(key: key);

  QuestionWidget.modeReview(this.questionData, this._selectedAnswer,
      {Key? key, this.onSelectAnswer, this.mode = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildContent(context, this.questionData);
  }

  Widget buildContent(BuildContext context, QuestionModel quiz) {
    var answers = List<Widget>.generate(quiz.answers.length,
        (index) => buildAnswer(quiz.answers[index], index + 1),
        growable: true);

    if (quiz.imageurl.length > 1) {
      answers.insert(
          0,
          Image.network(
            quiz.imageurl,
            errorBuilder: (c, o, s) {
              return Image.network(
                "https://i-vnexpress.vnecdn.net/2020/09/01/q@.png"
                    .replaceAll("@", quiz.id.toString()),
                errorBuilder: (c, o, s) {
                  return const Text(
                    'Không tìm thấy ảnh',
                    style: TextStyle(color: Colors.red),
                  );
                },
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
          ],
        ),
      ),
    );
  }

  Widget buildAnswer(String content, int index) {
    var primecolor = dtcolor11;
    String iconPath = 'assets/icons/quiz_check_unselected.svg';

    if (mode == 0) {
      if (_selectedAnswer == index) {
        // Selected
        primecolor = dtcolor1;
        iconPath = 'assets/icons/quiz_check_selected.svg';
      }
    } else if (mode == 1) {
      if (_correctAnswer == index) {
        // Correct
        primecolor = dtcolor5;
      }
      if (_selectedAnswer == index) {
        if (_correctAnswer != index) {
          // Selected wrong
          primecolor = dtcolor4;
          iconPath = 'assets/icons/quiz_check_wrong.svg';
        } else {
          // Selected correct
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
        onTap: () => onSelectAnswer?.call(index, _correctAnswer),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: SvgPicture.asset(iconPath)),
            Expanded(
              child: Text(
                content,
                style: kText16Normal_14.copyWith(
                    color: primecolor, fontSize: 16.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizNavigationWidgetState {
  List<int> selected;
  List<int> correct;
  int mode;
  QuizNavigationWidgetState({
    required this.mode,
    required this.selected,
    required this.correct,
  });
}

class QuizNavigationWidget extends StatelessWidget {
  final List<int> selected;
  final int mode;
  final Function(int index)? onSelect;

  late final List<int> correct;

  int get maximum => selected.length;
  int _getCorrectIndex(int index) => correct.elementAt(index);

  QuizNavigationWidget(this.selected, this.correct, this.mode,
      {Key? key, this.onSelect})
      : super(key: key);
  QuizNavigationWidget.modeStart(this.selected,
      {this.mode = 0, Key? key, this.onSelect})
      : super(key: key);
  QuizNavigationWidget.modeReview(this.selected, this.correct,
      {this.mode = 1, Key? key, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstLine = new List<Widget>.empty(growable: true);
    for (int i = 0; i < maximum && i < 10; i++) {
      firstLine.add(getQuesNavigationIcon(i));
    }
    var secondLine = new List<Widget>.empty(growable: true);
    for (int i = 10; i < maximum && i < 20; i++) {
      secondLine.add(getQuesNavigationIcon(i));
    }
    var thirdLine = new List<Widget>.empty(growable: true);
    for (int i = 20; i < maximum && i < 30; i++) {
      thirdLine.add(getQuesNavigationIcon(i));
    }
    var fourLine = new List<Widget>.empty(growable: true);
    for (int i = 30; i < maximum && i < 40; i++) {
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

  Widget getQuesNavigationIcon(int index) {
    String path = 'assets/icons/button_quiz_navi_normal.svg';
    if (mode == 0) {
      if (selected[index] > 0) {
        // Selected
        path = 'assets/icons/button_quiz_navi_selected.svg';
      }
    } else if (mode == 1) {
      if (selected[index] == _getCorrectIndex(index)) {
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
      onPressed: () => onSelect?.call(index),
    );
  }
}
