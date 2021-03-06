import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Quiz/questionWidget.dart';
import 'package:sathachlaixe/UI/Quiz/quizButtonBar.dart';
import 'package:sathachlaixe/UI/Quiz/quizClock.dart';
import 'package:sathachlaixe/UI/Quiz/quizNavigation.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
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
      state = QuizState.fromTopic(
        title: title,
        topic: topic,
      );
    } else if (mode == 1) {
      state = QuizState.fromHistory(
        title: title,
        topic: topic,
        history: history as HistoryModel,
      );
    } else if (mode == 2) {
      state = QuizState.fromHistory(
        title: title,
        topic: topic,
        history: history as HistoryModel,
        mode: 2,
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

  Future<bool> _onPressBack(BuildContext context) {
    return Future.value(
        BlocProvider.of<QuizBloc>(context).onPressBack(context));
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

  void _onPressSubmit(BuildContext context) {
    BlocProvider.of<QuizBloc>(context).onPressSubmit(context);
  }

  bool checkChanged(QuizState previous, QuizState current) {
    return current.selectedAnswer != previous.selectedAnswer ||
        current.currentIndex != previous.currentIndex ||
        current.mode != previous.mode;
  }

  @override
  Widget build(BuildContext context) {
    log("Build QuizPage");
    BlocProvider.of<QuizBloc>(context).startTimer(context);

    return WillPopScope(
      onWillPop: () {
        return _onPressBack(context);
      },
      child: SafeArea(
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
                  buildTopBar(context),
                  buildNavigator(context),
                  Container(
                    margin: EdgeInsets.only(
                        left: 25.w, right: 15.w, top: 10.h, bottom: 5.h),
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
                              current.mode != previous.mode ||
                              current.timeLeft != previous.timeLeft,
                          builder: (context, state) => buildquizClock(
                              context, state.mode, state.timeLeft),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BlocBuilder<QuizBloc, QuizState>(
                              buildWhen: (previous, current) =>
                                  current.currentIndex != previous.currentIndex,
                              builder: (context, state) =>
                                  buildQuestion(context, state),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: BlocBuilder<QuizBloc, QuizState>(
                              buildWhen: (previous, current) =>
                                  previous.currentIndex !=
                                      current.currentIndex ||
                                  previous.mode != current.mode,
                              builder: (context, state) => buildButtonBar(
                                  context,
                                  state.mode,
                                  state.currentIndex,
                                  state.length),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Row(
        children: <Widget>[
          BackButtonComponent.withCallback(
            callback: () => _onPressBack(context),
          ),
          SizedBox(
            width: 95.w,
          ),
          Text(
            title,
            style: kText20Bold_13,
          ),
        ],
      ),
    );
  }

  Widget buildNavigator(BuildContext context) {
    double heightNavigator =
        repository.getTopoicDemos().first.questionIDs.length > 30
            ? 160.h
            : 120.h;

    return SizedBox(
      height: heightNavigator,
      width: 320.w,
      child: Container(
        constraints: BoxConstraints(minHeight: 120.h),
        child: BlocBuilder<QuizBloc, QuizState>(
          buildWhen: (previous, current) => checkChanged(previous, current),
          builder: (context, state) {
            if (state.mode == 1) {
              return QuizNavigationWidget.modeReview(
                state.getSelectedListInt(),
                state.getCorrectListInt(),
                onSelect: (i) => _onChangeNavigation(context, i),
              );
            } else {
              return QuizNavigationWidget.modeStart(
                state.getSelectedListInt(),
                onSelect: (i) => _onChangeNavigation(context, i),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildquizClock(BuildContext context, int mode, Duration timeLeft) {
    if (mode == 1) {
      return Container();
    } else {
      return QuizClock(
        timeLeft,
      );
    }
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
                    state.selectedAnswer,
                    onSelectAnswer: (select, correct) =>
                        _onSelectAnswer(context, select, correct),
                  );
                } else {
                  return QuestionWidget.modeReview(
                    quesData,
                    state.selectedAnswer,
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

  Widget buildButtonBar(BuildContext context, int mode, int index, int length) {
    String text = mode == 1 ? "LÀM LẠI" : "NỘP BÀI";

    return QuizButtonBar(
      submitText: text,
      // showLeftButton: index > 0,
      // showRightButton: index < length - 1,
      onPressNext: () => index == length - 1
          ? BlocProvider.of<QuizBloc>(context).selectQuestion(0)
          : _onPressNext(context),
      onPressPrevious: () => index == 0
          ? BlocProvider.of<QuizBloc>(context).selectQuestion(length - 1)
          : _onPressPrevious(context),
      onPressSubmit: () {
        _onPressSubmit(context);
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
        Text('Câu ' + (questionIndex + 1).toString(), style: kText20Normal_13),
        Text('/' + count.toString(), style: kText14Medium_13),
      ],
    );
  }
}
