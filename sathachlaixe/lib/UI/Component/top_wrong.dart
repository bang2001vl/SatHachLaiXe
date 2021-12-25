import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sathachlaixe/UI/Board/boardCategoryList.dart';
import 'package:sathachlaixe/UI/Board/boardDetailList.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TopWrongItem extends StatelessWidget {
  const TopWrongItem({
    Key? key,
    required this.top,
    required this.name,
    required this.cate,
    required this.wrongTime,
  }) : super(key: key);
  final String name, cate;
  final int wrongTime, top;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(vertical: 7.h),
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: dtcolor16,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${top}',
            style: kText30Bold_1,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: kText18Medium_14,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        cate,
                        style: kText14Normal_11,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: cwcolor22,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('${wrongTime} lần', style: kText16Bold_1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
