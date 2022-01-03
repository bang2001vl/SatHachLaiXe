import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/quesContainer.dart';
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
import 'package:scroll_to_index/scroll_to_index.dart';

class QuizStudyScreen extends StatelessWidget {
  late final QuestionCategoryModel cate;
  final int mode;

  bool get isModeStudy => mode == 0;
  bool get isModePractice => mode == 1;

  QuizStudyScreen({required this.cate, required this.mode, Key? key})
      : super(key: key);
  QuizStudyScreen.modeStudy({required this.cate, this.mode = 0, Key? key})
      : super(key: key);
  QuizStudyScreen.modePratice(List<String> questionIDs,
      {this.mode = 1, Key? key})
      : super(key: key) {
    this.cate = QuestionCategoryModel(
        name: "Ôn tập", detail: "null", questionIDs: questionIDs);
  }

  void _onPressBack(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).onPressBack(context);
  }

  void _onSelectAnswer(
      BuildContext context, int select, int correct, QuestionModel quesData) {
    repository
        .insertOrUpdatePracticeAnswer(
            PracticeModel(quesData.id, select, correct, 0, 0))
        .then((_) => BlocProvider.of<PracticeBloc>(context)
            .selectAnswer(select, correct));
  }

  void _onPressNext(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).selectQuestionNext();
  }

  void _onPressPrevious(BuildContext context) {
    BlocProvider.of<PracticeBloc>(context).selectQuestionPrevious();
    void _changeQuestionIndex(BuildContext context, int index) {
      BlocProvider.of<PracticeBloc>(context).selectQuestion(index);
    }
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
            endDrawer: buildTab(context),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: BlocBuilder<PracticeBloc, QuizState>(
                builder: buildBackButton,
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                state.title,
                style: kText18Bold_13,
              ),
            ),
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
    return [
      Container(
        margin: EdgeInsets.only(left: 20.w, right: 15.w, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<PracticeBloc, QuizState>(
              buildWhen: (previous, current) =>
                  current.currentIndex != previous.currentIndex,
              builder: (context, state) {
                if (isModeStudy) {
                  return QuizTitle(
                      questionIndex: state.currentIndex, count: state.length);
                } else if (isModePractice) {
                  return Text('Câu ' + (state.currentQuestionId).toString(),
                      style: kText20Normal_13);
                }
                throw UnimplementedError();
              },
            ),
            BlocBuilder<PracticeBloc, QuizState>(
              buildWhen: (previous, current) =>
                  current.timeLeft != previous.timeLeft,
              builder: (context, state) => _QuizNotify(
                isCritical: repository.checkCritical(state.currentQuestionId),
              ),
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
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<PracticeBloc, QuizState>(
                  buildWhen: (previous, current) =>
                      current.currentIndex != previous.currentIndex,
                  builder: (context, state) =>
                      buildQuestion(context, state.currentQuestionId),
                ),
              ),
              // BlocBuilder<PracticeBloc, QuizState>(
              //   buildWhen: (prev, cur) =>
              //       prev.currentQuestionId != cur.currentQuestionId,
              //   builder: (context, state) =>
              //       buildHintWithFuture(context, state.currentQuestionId),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: BlocBuilder<PracticeBloc, QuizState>(
                  buildWhen: (previous, current) =>
                      current.currentIndex != previous.currentIndex,
                  builder: (context, state) => buildButtonBar(
                      context, state.currentIndex, state.questionIds.length),
                ),
              ),
            ],
          ),
        ),
      )
    ];
  }

  Widget buildBackButton(BuildContext context, QuizState state) {
    return BackButtonComponent.withCallback(
      callback: () => _onPressBack(context),
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

            if (isModeStudy) {
              // Only get previous answer when in mode == 0
              if (practiceData.isNotEmpty) {
                BlocProvider.of<PracticeBloc>(context).selectAnswer(
                  practiceData.first.selectedAnswer,
                  practiceData.first.correctAnswer,
                );
              }
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
          style: kText20Bold_1,
        ),
      );
  }

  Widget buildTab(BuildContext context) {
    return BlocBuilder<PracticeBloc, QuizState>(
        builder: (context, state) => FutureBuilder<List<PracticeModel>>(
            future: repository.getPracticeList(state.getQuestionIDsListInt()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return BlocBuilder<PracticeBloc, QuizState>(
                    builder: (context, state) =>
                        buildQuesContainer(context, snapshot.data!, state));
              }
              if (snapshot.hasError) {
                return buildError(context, snapshot.error!);
              }
              // Loading
              return buildLoading(context);
            }));
  }

  Widget buildQuesContainer(
      BuildContext context, List<PracticeModel> data, QuizState state) {
    final scrollController = ScrollController();
    double height = MediaQuery.of(context).size.height;
    Container container = Container(
        width: 120.w,
        height: double.infinity,
        color: dtcolor13,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: GridView.builder(
            controller: scrollController,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50,
              childAspectRatio: 1 / 1,
            ),
            itemCount: state.questionIds.length,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<PracticeBloc>(context)
                        .selectQuestion(index);
                  },
                  child: QuesContainerItem(
                    currentIndex: state.currentIndex + 1,
                    index: index + 1,
                    correct: data[index].correctAnswer,
                    selected: data[index].selectedAnswer,
                  ));
            }));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int t = ((state.currentIndex) ~/ 3);
      double scrollTo = state.currentIndex ~/ 3 * 45.h;
      if (state.questionIds.length * 15.h > height) {
        scrollController.jumpTo(scrollTo);
      }
    });
    return container;
  }

  Widget buildButtonBar(BuildContext context, int index, int length) {
    String text = (index + 1).toString() + "/" + length.toString();

    return QuizButtonBar(
      submitText: text,
      // showLeftButton: index > 0,
      // showRightButton: index < length - 1,
      onPressNext: () => index == length - 1
          ? BlocProvider.of<PracticeBloc>(context).selectQuestion(0)
          : _onPressNext(context),
      onPressPrevious: () => index == 0
          ? BlocProvider.of<PracticeBloc>(context).selectQuestion(length - 1)
          : _onPressPrevious(context),
      onPressSubmit: () {
        //Navigator.pop(context, "Submit");
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
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/quiz_clock_bg.svg',
            width: 120.w,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5,
              ),
              Text(
                "Câu điểm liệt",
                style: kText14Medium_13,
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
