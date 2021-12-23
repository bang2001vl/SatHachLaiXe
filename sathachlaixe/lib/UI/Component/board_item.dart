import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BoardItem extends StatelessWidget {
  const BoardItem({
    Key? key,
    required this.imageSrc,
    required this.name,
    required this.subtitle,
  }) : super(key: key);
  final String imageSrc, name, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: dtcolor13,
        border: Border(bottom: BorderSide(color: dtcolor7, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100.h,
            width: 100.h,
            margin: EdgeInsets.only(right: 15.h),
            child: Image.asset(imageSrc),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: kText18Medium_14,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(subtitle, style: kText14Normal_11),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
