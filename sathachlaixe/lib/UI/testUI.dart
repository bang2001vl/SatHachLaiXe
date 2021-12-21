import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Quiz/questionWidget.dart';
import 'package:sathachlaixe/UI/Quiz/quizButtonBar.dart';
import 'package:sathachlaixe/UI/Quiz/quizClock.dart';
import 'package:sathachlaixe/UI/Quiz/quizNavigation.dart';
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
    String text = state.mode == 1 ? "XONG" : "NỘP BÀI";

    return QuizButtonBar(
      submitText: text,
      onPressNext: () => _onPressNext(context),
      onPressPrevious: () => _onPressPrevious(context),
      onPressSubmit: () {
        if (state.mode == 1) {
          Navigator.pop(context, "Review");
        } else {
          _onPressSubmit(context, state);
        }
      },
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
