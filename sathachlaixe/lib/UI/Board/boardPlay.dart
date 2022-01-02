import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sathachlaixe/UI/Board/boardFlipCard.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Quiz/questionWidget.dart';
import 'package:sathachlaixe/UI/Quiz/quizButtonBar.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/UI/testUI.dart';
import 'package:sathachlaixe/bloc/boardFlipBloc.dart';
import 'package:sathachlaixe/bloc/practiceBloc.dart';
import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/state/boardFlip.dart';
import 'package:sathachlaixe/state/quiz.dart';

class BoardPlayScreen extends StatelessWidget {
  final BoardCategoryModel cate;
  BoardPlayScreen({required this.cate, Key? key}) : super(key: key);

  void _onPressNext(BuildContext context) {
    BlocProvider.of<BoardFlipBloc>(context).selectBoardNext();
  }

  void _onPressPrevious(BuildContext context) {
    BlocProvider.of<BoardFlipBloc>(context).selectBoardPrevious();
  }

  @override
  Widget build(BuildContext context) {
    log("Build at BoardPlayScreen");
    String title = "Ôn tập";
    var state = BoardPlayState.fromCategory(cate: cate, title: cate.name);

    return BlocProvider(
      create: (_) => BoardFlipBloc(state),
      child: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            color: dtcolor13,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    color: dtcolor8,
                  ),
                ),
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
      ),
    );
  }

  List<Widget> buildMainColumn(BuildContext context) {
    return [
      BlocBuilder<BoardFlipBloc, BoardPlayState>(
        builder: buildTopBar,
      ),
      Padding(
        padding: EdgeInsets.only(top: 20.h, left: 40.w, right: 40.w),
        child: BlocBuilder<BoardFlipBloc, BoardPlayState>(
          buildWhen: (previous, current) =>
              current.currentIndex != previous.currentIndex,
          builder: (context, state) => buildProgressBar(
              context, state.currentIndex, state.boards.length),
        ),
      ),
      Expanded(
        child: Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.all(40.w),
          child: BlocBuilder<BoardFlipBloc, BoardPlayState>(
            buildWhen: (previous, current) =>
                current.currentIndex != previous.currentIndex,
            builder: (context, state) =>
                buildBoard(context, state.currentBoard),
          ),
        ),
        // BlocBuilder<PracticeBloc, QuizState>(
        //   buildWhen: (prev, cur) =>
        //       prev.currentQuestionId != cur.currentQuestionId,
        //   builder: (context, state) =>
        //       buildHintWithFuture(context, state.currentQuestionId),
        // ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: BlocBuilder<BoardFlipBloc, BoardPlayState>(
          buildWhen: (previous, current) =>
              current.currentIndex != previous.currentIndex,
          builder: (context, state) =>
              buildButtonBar(context, state.currentIndex, state.boards.length),
        ),
      ),
    ];
  }

  Widget buildTopBar(BuildContext context, BoardPlayState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      child: Row(
        children: <Widget>[
          CloseButton(),
          SizedBox(
            width: 80.w,
          ),
          Text(
            state.title,
            style: kText20Bold_13.copyWith(color: dtcolor17),
          ),
        ],
      ),
    );
  }

  Widget buildBoard(BuildContext context, int currentBoardId) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.getBoard(currentBoardId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data![0] != null) {
            // Load OK
            var boardData = snapshot.data![0] as BoardModel;

            return BlocBuilder<BoardFlipBloc, BoardPlayState>(
              builder: (context, state) => buildBoardContent(
                context,
                boardData,
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

  Widget buildBoardContent(BuildContext context, BoardModel board) {
    return BoardFlipCard(item: board);
  }

  Widget buildProgressBar(BuildContext context, int index, int length) {
    return LinearPercentIndicator(
      lineHeight: 7.h,
      backgroundColor: dtcolor13,
      percent: (index + 1) / length,
      progressColor: dtcolor17,
    );
  }

  Widget buildButtonBar(BuildContext context, int index, int length) {
    String text = (index + 1).toString() + "/" + length.toString();

    return ButtonBar(
      submitText: text,
      // showLeftButton: index > 0,
      // showRightButton: index < length - 1,
      onPressNext: () => index == length - 1
          ? BlocProvider.of<BoardFlipBloc>(context).selectQuestion(0)
          : _onPressNext(context),
      onPressPrevious: () => index == 0
          ? BlocProvider.of<PracticeBloc>(context).selectQuestion(length - 1)
          : _onPressPrevious(context),
    );
  }
}

class ButtonBar extends StatelessWidget {
  final Function()? onPressPrevious;
  final Function()? onPressNext;
  final String submitText;
  final bool showLeftButton;
  final bool showRightButton;

  ButtonBar(
      {required this.submitText,
      this.showLeftButton = true,
      this.showRightButton = true,
      this.onPressPrevious,
      this.onPressNext,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLeftButton(context),
          GestureDetector(
            child: Container(
              height: 50.h,
              width: 150.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                color: dtcolor1,
              ),
              alignment: Alignment.center,
              child: Text(
                this.submitText,
                style: kText18Bold_13,
              ),
            ),
            onTap: () {},
          ),
          buildRightButton(context),
        ],
      ),
    );
  }

  Widget buildLeftButton(BuildContext context) {
    double size = 50.h;
    if (showLeftButton) {
      return IconButton(
        onPressed: () => onPressPrevious?.call(),
        iconSize: size,
        icon: SvgPicture.asset('assets/icons/previousButton.svg'),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
      );
    }
  }

  Widget buildRightButton(BuildContext context) {
    double size = 50.h;
    if (showRightButton) {
      return IconButton(
        onPressed: () => onPressNext?.call(),
        iconSize: size,
        icon: SvgPicture.asset('assets/icons/nextButton.svg'),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
      );
    }
  }
}
