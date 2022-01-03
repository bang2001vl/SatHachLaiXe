import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/model/question.dart';

class QuesContainerItem extends StatelessWidget {
  const QuesContainerItem({
    Key? key,
    required this.currentIndex,
    required this.index,
    required this.correct,
    required this.selected,
  }) : super(key: key);
  final int index, correct, selected, currentIndex;

  @override
  Widget build(BuildContext context) {
    var primecolor = dtcolor13;
    var borderColor = dtcolor5;
    var textColor = dtcolor11;
    if (index != currentIndex) {
      if (selected > 0) {
        textColor = dtcolor13;
        if (selected == correct) {
          // Selected
          primecolor = dtcolor5;
        } else {
          // Correct
          borderColor = dtcolor4;
          primecolor = dtcolor4;
        }
      }
    } else {
      textColor = dtcolor13;
      borderColor = cwcolor26;
      primecolor = cwcolor26;
    }

    return Padding(
      padding: EdgeInsets.all(5.h),
      child: Container(
          width: 60.h,
          height: 60.h,
          decoration: BoxDecoration(
            color: primecolor,
            border: Border.all(color: borderColor, width: 1.5.w),
          ),
          child: Center(
            child: Text('${index}',
                style: kText14Medium_13.copyWith(color: textColor)),
          )),
    );
  }
}
