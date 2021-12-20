import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TestStartedComponent extends StatelessWidget {
  final bool isPassed;
  final bool isFinished;
  final String title;
  final int totalQues;
  final int trueQues;
  final int completeQues;

  const TestStartedComponent({
    Key? key,
    required this.isPassed,
    required this.isFinished,
    required this.title,
    required this.totalQues,
    required this.trueQues,
    required this.completeQues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String result;
    String trueText;
    int percentTest;
    if (isFinished) {
      color = (isPassed == true ? dtcolor5 : dtcolor4);
      result = (isPassed == true ? "Đạt bài thi" : "Không đạt bài thi");
      percentTest = ((trueQues / totalQues) * 100).toInt();
      trueText = trueQues.toString() + "/" + totalQues.toString();
    } else {
      color = dtcolor15;
      result = "Đang làm";
      percentTest = (completeQues / totalQues).toInt();
      trueText = completeQues.toString() + "/" + totalQues.toString();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.left,
                style: kText20Bold_6,
              ),
              SizedBox(
                height: 10.h,
              ),
              CircularPercentIndicator(
                radius: 120.h,
                lineWidth: 12.h,
                percent: (percentTest / 100),
                center: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 33.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          percentTest.toString() + "%",
                          style: kText30Bold_6.copyWith(color: color),
                        ),
                        Text(
                          trueQues.toString() + "/30",
                          style: kText16Normal_6,
                        ),
                      ]),
                ),
                progressColor: color,
              ),
              SizedBox(
                height: 13.h,
              ),
              Text(
                result,
                style: kText20Bold_13.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
