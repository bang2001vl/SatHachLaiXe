import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TestUnstartedComponent extends StatelessWidget {
  final String title;
  final int totalQues;
  final Duration time;

  const TestUnstartedComponent({
    Key? key,
    required this.title,
    required this.totalQues,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.all(20),
        child: Padding(
          padding:
              EdgeInsets.only(left: 15.h, right: 15.h, top: 15.h, bottom: 5.h),
          child: Column(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.left,
                style: kText16Bold_6,
              ),
              SizedBox(
                height: 10.h,
              ),
              CircularPercentIndicator(
                radius: 120.h,
                lineWidth: 12.h,
                percent: 1,
                center: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 45.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Mở",
                          style: kText26Bold_6.copyWith(color: dtcolor1),
                        ),
                      ]),
                ),
                progressColor: dtcolor1,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                totalQues.toString() + " câu hỏi",
                style: kText12Normal_6,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                time.inMinutes.toString() + " phút",
                style: kText12Normal_6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
