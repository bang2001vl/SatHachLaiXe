import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Quiz/questionWidget.dart';
import 'package:sathachlaixe/UI/Quiz/quizButtonBar.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/UI/testUI.dart';
import 'package:sathachlaixe/bloc/quizBloc.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/state/quiz.dart';

class QuizStudyScreen extends StatelessWidget {
  final QuestionCategoryModel cate;
  final int mode;
  QuizStudyScreen({required this.cate, required this.mode, Key? key})
      : super(key: key);
  QuizStudyScreen.modeStudy({required this.cate, this.mode = 0, Key? key})
      : super(key: key);

  void _onPressBack(BuildContext context, QuizState state) {}

  void _onSelectAnswer(BuildContext context, int select, int correct) {
    BlocProvider.of<QuizBloc>(context).selectAnswer(select, correct);
  }

  void _onChangeNavigation(BuildContext context, int index) {
    log("navigation to " + index.toString());
    BlocProvider.of<QuizBloc>(context).selectQuestion(index);
  }

  void _onPressNext(BuildContext context) {
    _onChangeNavigation(
        context, BlocProvider.of<QuizBloc>(context).state.currentIndex + 1);
  }

  void _onPressPrevious(BuildContext context) {
    _onChangeNavigation(
        context, BlocProvider.of<QuizBloc>(context).state.currentIndex - 1);
  }

  void _onPressSubmit(BuildContext context, QuizState state) {
    BlocProvider.of<QuizBloc>(context).stopTimer();
    if (state.selectedList.contains("0")) {
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
        if (value == "Ok") {}
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    log("Build at QuizStudyScreen");
    String title = "Ôn tập";
    var state = QuizState.fromCategory(cate: cate, title: cate.name);

    return BlocProvider(
      create: (_) => QuizBloc(state),
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
                  BlocBuilder<QuizBloc, QuizState>(
                    builder: buildTopBar,
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
                          builder: (context, state) => _QuizNotify(
                              isCritical: repository
                                  .checkCritical(state.currentQuestionId)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<QuizBloc, QuizState>(
                      buildWhen: (previous, current) =>
                          current.currentIndex != previous.currentIndex,
                      builder: (context, state) =>
                          buildQuestion(context, state),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, left: 20.w),
                    child: Text(
                      'Đáp án đúng là A',
                      style: kText24Bold_1,
                    ),
                  ),
                  SizedBox(
                    height: 55.h,
                    child: BlocBuilder<QuizBloc, QuizState>(
                      buildWhen: (previous, current) =>
                          current.mode != previous.mode,
                      builder: (context, state) =>
                          buildButtonBar(context, state),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
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
            state.title,
            style: kText22Bold_13.copyWith(fontSize: 22.h),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(BuildContext context, QuizState state) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.getQuestion(state.currentQuestionId),
          repository.getPractice(state.currentIndex),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data![0] != null) {
            // Load OK
            var quesData = snapshot.data![0] as QuestionModel;
            var practiceData = (snapshot.data![1] as List<PracticeModel>);
            return BlocBuilder<QuizBloc, QuizState>(
              buildWhen: (prev, curr) =>
                  prev.selectedAnswer != curr.selectedAnswer ||
                  prev.mode != curr.mode,
              builder: (context, state) {
                if (practiceData.isEmpty) {
                  return QuestionWidget.modeStart(
                    quesData,
                    state.selectedAnswer,
                    onSelectAnswer: (select, correct) {
                      var practice =
                          PracticeModel(quesData.id, select, correct, 0, 0);
                      repository.insertPractice(practice).then(
                          (_) => _onSelectAnswer(context, select, correct));
                    },
                  );
                } else {
                  return QuestionWidget.modeReview(
                    quesData,
                    state.selectedAnswer,
                    onSelectAnswer: (select, correct) {
                      var old = practiceData.first;
                      old.selectedAnswer = select;
                      old.correctAnswer = correct;
                      repository.updatePractice(old).then(
                          (_) => _onSelectAnswer(context, select, correct));
                    },
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

class _QuizNotify extends StatelessWidget {
  final bool isCritical;
  _QuizNotify({
    required this.isCritical,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCritical) {
      return Container(
        height: 25.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38),
          color: dtcolor1,
        ),
        alignment: Alignment.center,
        child: Text(
          "Câu điểm liệt",
          style: kText14Normal_10,
        ),
      );
    } else {
      return Container();
    }
  }
}
