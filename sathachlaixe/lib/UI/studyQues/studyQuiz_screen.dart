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
import 'package:sathachlaixe/bloc/practiceBloc.dart';
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

  void _onPressBack(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).onPressBack(context);
  }

  void _onSelectAnswer(
      BuildContext context, int select, int correct, QuestionModel quesData) {
    repository.insertOrUpdatePractice(quesData.id, select, correct).then((_) =>
        BlocProvider.of<PracticeBloc>(context).selectAnswer(select, correct));
  }

  void _onPressNext(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).selectQuestionNext();
  }

  void _onPressPrevious(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).selectQuestionPrevious();
  }

  void _onPressSubmit(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).onPressSubmit(context);
  }

  bool checkChanged(QuizState previous, QuizState current) {
    return current.selectedAnswer != previous.selectedAnswer ||
        current.currentIndex != previous.currentIndex ||
        current.mode != previous.mode;
  }

  @override
  Widget build(BuildContext context) {
    log("Build at QuizStudyScreen");
    String title = "Ôn tập";
    var state = QuizState.fromCategory(cate: cate, title: cate.name);

    return BlocProvider(
      create: (_) => PracticeBloc(state),
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
                children: buildMainColumn(context),
              ),
            ),
          )
        ],
      )),
    );
  }

  List<Widget> buildMainColumn(BuildContext context) {
    double topbarHeight = 50.h;
    double butonBarHeight = 70.h;
    double questionTitleheight = 80.h;
    double questionContentHeight = MediaQuery.of(context).size.height -
        topbarHeight -
        butonBarHeight -
        questionTitleheight -
        50.h;
    return [
      SizedBox(
        height: topbarHeight,
        child: BlocBuilder<PracticeBloc, QuizState>(
          builder: buildTopBar,
        ),
      ),
      SizedBox(
        height: questionTitleheight,
        child: Container(
          margin: EdgeInsets.only(left: 25.w, right: 15.w),
          constraints: BoxConstraints(minHeight: 50.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<PracticeBloc, QuizState>(
                buildWhen: (previous, current) =>
                    current.currentIndex != previous.currentIndex,
                builder: (context, state) => QuizTitle(
                  questionIndex: state.currentIndex,
                  count: state.length,
                ),
              ),
              BlocBuilder<PracticeBloc, QuizState>(
                buildWhen: (previous, current) =>
                    current.timeLeft != previous.timeLeft,
                builder: (context, state) => _QuizNotify(
                    isCritical:
                        repository.checkCritical(state.currentQuestionId)),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: BlocBuilder<PracticeBloc, QuizState>(
          buildWhen: (previous, current) =>
              current.currentIndex != previous.currentIndex,
          builder: (context, state) =>
              buildQuestion(context, state.currentQuestionId),
        ),
      ),
      BlocBuilder<PracticeBloc, QuizState>(
        buildWhen: (prev, cur) =>
            prev.currentQuestionId != cur.currentQuestionId,
        builder: (context, state) =>
            buildHintWithFuture(context, state.currentQuestionId),
      ),
      SizedBox(
        height: butonBarHeight,
        child: BlocBuilder<PracticeBloc, QuizState>(
          buildWhen: (previous, current) => current.mode != previous.mode,
          builder: (context, state) => buildButtonBar(context, state),
        ),
      )
    ];
  }

  Widget buildTopBar(BuildContext context, QuizState state) {
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
            state.title,
            style: kText22Bold_13.copyWith(fontSize: 22.h),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(BuildContext context, int currentQuestionId) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.getQuestion(currentQuestionId),
          repository.getPractice(currentQuestionId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data![0] != null) {
            // Load OK
            var quesData = snapshot.data![0] as QuestionModel;
            var practiceData = (snapshot.data![1] as List<PracticeModel>);

            if (practiceData.isNotEmpty) {
              BlocProvider.of<PracticeBloc>(context).selectAnswer(
                practiceData.first.selectedAnswer,
                practiceData.first.correctAnswer,
              );
            }

            return BlocBuilder<PracticeBloc, QuizState>(
              buildWhen: (prev, curr) =>
                  prev.selectedAnswer != curr.selectedAnswer ||
                  prev.mode != curr.mode,
              builder: (context, state) => buildQuestionContent(
                context,
                quesData,
                state.selectedAnswer,
                practice: practiceData.isNotEmpty ? practiceData.first : null,
              ),
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

  Widget buildQuestionContent(
      BuildContext context, QuestionModel quesData, int selected,
      {PracticeModel? practice}) {
    if (selected == 0) {
      return QuestionWidget.modeStart(
        quesData,
        selected,
        onSelectAnswer: (select, correct) => _onSelectAnswer(
          context,
          select,
          correct,
          quesData,
        ),
      );
    } else {
      return QuestionWidget.modeReview(
        quesData,
        selected,
        onSelectAnswer: (select, correct) =>
            _onSelectAnswer(context, select, correct, quesData),
      );
    }
  }

  Widget buildHintWithFuture(BuildContext context, int currentQuestionId) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.getQuestion(currentQuestionId),
          repository.getPractice(currentQuestionId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data![0] != null) {
            // Load OK
            var quesData = snapshot.data![0] as QuestionModel;
            var practiceData = (snapshot.data![1] as List<PracticeModel>);

            if (practiceData.isNotEmpty) {
              BlocProvider.of<PracticeBloc>(context).selectAnswer(
                practiceData.first.selectedAnswer,
                practiceData.first.correctAnswer,
              );
            }

            return BlocBuilder<PracticeBloc, QuizState>(
              buildWhen: (prev, curr) =>
                  prev.selectedAnswer != curr.selectedAnswer ||
                  prev.mode != curr.mode,
              builder: (context, state) =>
                  buildHint(context, quesData, state.selectedAnswer),
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

  Widget buildHint(BuildContext context, QuestionModel data, int select) {
    if (select == 0 || select == data.correct)
      return Container();
    else
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 20.w),
        child: Text(
          'Đáp án đúng là ' + data.correct.toString(),
          style: kText24Bold_1,
        ),
      );
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
          _onPressSubmit(context);
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
