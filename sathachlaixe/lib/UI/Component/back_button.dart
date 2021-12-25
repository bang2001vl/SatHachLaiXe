import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonComponent extends StatelessWidget {
  BackButtonComponent({Key? key}) : super(key: key);
  Function? callback;
  BackButtonComponent.withCallback({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: callback == null
            ? () => Navigator.pop(context)
            : () => callback?.call(),
        iconSize: 40.h,
        icon: SvgPicture.asset('assets/icons/back.svg'),
      ),
    );
  }
}
