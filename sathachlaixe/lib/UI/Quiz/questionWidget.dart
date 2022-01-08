import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/model/question.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel questionData;
  final int _selectedAnswer;
  final int mode;
  final String? countWrong;
  final Function(int select, int correct)? onSelectAnswer;
  int get _correctAnswer => questionData.correct;

  QuestionWidget(this.questionData, this._selectedAnswer, this.mode,
      {Key? key, this.onSelectAnswer, this.countWrong})
      : super(key: key);

  QuestionWidget.modeStart(this.questionData, this._selectedAnswer,
      {Key? key, this.onSelectAnswer, this.mode = 0, this.countWrong})
      : super(key: key);

  QuestionWidget.modeReview(this.questionData, this._selectedAnswer,
      {Key? key, this.onSelectAnswer, this.mode = 1, this.countWrong})
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
        Image.asset("assets/images/question/p@.png"
            .replaceAll("@", quiz.id.toString())),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: 10.h, bottom: 20.h, left: 10.w, right: 10.w),
            child: RichText(
              text: TextSpan(style: kText16Medium_14, children: [
                TextSpan(text: quiz.question),
                TextSpan(
                  text: countWrong == null ? "" : " (Sai $countWrong lần)",
                  style: kText16Medium_14.apply(
                    color: Colors.red,
                  ),
                ),
              ]),
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
    );
  }

  Widget buildAnswer(String content, int index) {
    var primecolor = dtcolor11;
    double borderThinkness = 1;
    String iconPath = 'assets/icons/quiz_check_unselected.svg';

    if (mode == 0) {
      if (_selectedAnswer == index) {
        // Selected
        primecolor = dtcolor1;
        borderThinkness = 1.5;
        iconPath = 'assets/icons/quiz_check_selected.svg';
      }
    } else if (mode == 1) {
      if (_correctAnswer == index) {
        // Correct
        borderThinkness = 2;
        primecolor = dtcolor5;
      }
      if (_selectedAnswer == index) {
        if (_correctAnswer != index) {
          // Selected wrong
          primecolor = dtcolor4;
          borderThinkness = 2;
          iconPath = 'assets/icons/quiz_check_wrong.svg';
        } else {
          // Selected correct
          primecolor = dtcolor5;
          borderThinkness = 2;
          iconPath = 'assets/icons/quiz_check_correct.svg';
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      constraints: BoxConstraints(minHeight: 45),
      decoration: BoxDecoration(
          border: Border.all(
            color: primecolor,
            width: borderThinkness,
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
                style: kText14Normal_6.copyWith(
                  color: primecolor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
