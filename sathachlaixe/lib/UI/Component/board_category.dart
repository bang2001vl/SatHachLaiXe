import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sathachlaixe/UI/Board/boardDetailList.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BoardCategoryItem extends StatelessWidget {
  _onClickedItem(BuildContext context, BoardCategoryItem item) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BoardDetailScreenWithBloc()));
  }

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
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
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
              margin: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(imageSrc),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
            ),
          ],
        ),
      ),
    );
  }
}
