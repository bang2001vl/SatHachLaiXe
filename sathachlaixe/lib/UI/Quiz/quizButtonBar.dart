import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';

class QuizButtonBar extends StatelessWidget {
  final Function()? onPressPrevious;
  final Function()? onPressNext;
  final Function()? onPressSubmit;
  final String submitText;

  QuizButtonBar(
      {required this.submitText,
      this.onPressPrevious,
      this.onPressSubmit,
      this.onPressNext,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => onPressPrevious?.call(),
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
            child: Text(
              this.submitText,
              style: kText22Bold_13,
            ),
          ),
          onTap: () {
            onPressSubmit?.call();
          },
        ),
        IconButton(
            onPressed: () => onPressNext?.call(),
            iconSize: 50.h,
            icon: SvgPicture.asset('assets/icons/nextButton.svg')),
      ],
    );
  }
}