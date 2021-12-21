import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BoardCategoryItem extends StatelessWidget {
  const BoardCategoryItem({
    Key? key,
    required this.imageSrc,
    required this.name,
    required this.subtitle,
  }) : super(key: key);
  final String imageSrc, name, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SafeArea(
        child: Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: dtcolor13,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100.h,
                width: 100.h,
                margin: EdgeInsets.only(left: 10.h),
                decoration: BoxDecoration(
                  color: dtcolor2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(imageSrc),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: kText16Medium_1.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(22.sp),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(subtitle, style: kText16Normal_11),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
