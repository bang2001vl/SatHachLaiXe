import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Test/result_screen.dart';
import 'package:sathachlaixe/UI/testUI.dart';
import 'package:sathachlaixe/bloc/quizBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/quiz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizStudyScreen extends StatelessWidget {
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
                buildTopBar(context, "title"),
                Container(
                    margin: EdgeInsets.only(left: 25.w, right: 15.w),
                    constraints: BoxConstraints(minHeight: 50.h),
                    child: QuizTitle(
                      questionIndex: 5,
                      count: 30,
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(child: QuestionWidget(1, 1)),
              ],
            ),
          ),
        )
      ],
    ));
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

Widget buildTopBar(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
    child: Row(
      children: <Widget>[
        ReturnButton(),
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

Widget buildButtonBar(BuildContext context, int count, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
          onPressed: () {},
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
          child: Row(
            children: [
              TextFormField(
                style: kText22Bold_13,
                decoration: const InputDecoration(labelText: "/${count}"),
              ),
              Text(
                "/${count}",
                style: kText22Bold_13,
              ),
            ],
          ),
        ),
      ),
      IconButton(
          onPressed: () {},
          iconSize: 50.h,
          icon: SvgPicture.asset('assets/icons/nextButton.svg')),
    ],
  );
}

class QuestionWidget extends StatelessWidget {
  late final QuestionModel model;
  final int _questionId;
  final int _selectedAnswer;

  int get _correctAnswer => model.correct;
  QuestionWidget(this._questionId, this._selectedAnswer, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildWithFuture(context);
  }

  Widget buildWithFuture(BuildContext context) {
    return FutureBuilder<QuestionModel?>(
        future: repository.getQuestion(_questionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            this.model = snapshot.data!;
            return buildContent(context, this.model);
          }

          if (snapshot.hasError) {
            return buildError(context, snapshot.error!);
          }

          return buildLoading(context);
        });
  }

  Widget buildError(BuildContext context, Object error) {
    return Center(child: Text("Có lỗi xảy ra"));
  }

  Widget buildLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
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
              child: Text(quiz.question, style: kText22Medium_14),
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
            Padding(
              padding: EdgeInsets.only(bottom: 10.h, left: 20.w),
              child: Text(
                'Đáp án đúng là A',
                style: kText24Bold_1,
              ),
            ),
            buildButtonBar(context, 30, 6)
          ],
        ),
      ),
    );
  }

  Widget buildAnswer(String content, int index) {
    var primecolor = dtcolor11;
    String iconPath = 'assets/icons/quiz_check_unselected.svg';

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
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: SvgPicture.asset(iconPath)),
            Expanded(
              child: Text(
                content,
                style: kText16Normal_14.copyWith(
                    color: primecolor, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildAnswer(String content, int index) {
  var primecolor = dtcolor11;
  String iconPath = 'assets/icons/quiz_check_unselected.svg';
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
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 40, child: SvgPicture.asset(iconPath)),
          Expanded(
            child: Text(
              content,
              style:
                  kText16Normal_14.copyWith(color: primecolor, fontSize: 16.h),
            ),
          ),
        ],
      ),
    ),
  );
}
