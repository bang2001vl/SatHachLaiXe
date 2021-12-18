import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReturnButton extends StatelessWidget {
  ReturnButton({Key? key}) : super(key: key);
  Function? callback;
  ReturnButton.withCallback({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: callback == null
            ? () => Navigator.pop(context)
            : () => callback?.call(),
        iconSize: 40.h,
        icon: SvgPicture.asset('assets/icons/backButton.svg'),
      ),
    );
  }
}
