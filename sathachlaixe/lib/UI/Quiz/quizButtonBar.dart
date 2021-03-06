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
  final bool showLeftButton;
  final bool showRightButton;

  QuizButtonBar(
      {required this.submitText,
      this.showLeftButton = true,
      this.showRightButton = true,
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
        buildLeftButton(context),
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
              style: kText18Bold_13,
            ),
          ),
          onTap: () {
            onPressSubmit?.call();
          },
        ),
        buildRightButton(context),
      ],
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
