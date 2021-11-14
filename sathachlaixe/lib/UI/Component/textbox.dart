import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 63.h,
      width: 370.w,
      decoration: BoxDecoration(
        color: textBoxBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final int maxLines;
  final String label;
  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: defaultText20.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(16),
            color: mainColor,
          ),
        ),
        SizedBox(
          height: 11.h,
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
