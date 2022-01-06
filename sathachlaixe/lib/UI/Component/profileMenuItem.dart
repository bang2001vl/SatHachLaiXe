import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.iconSrc,
    required this.title,
    required this.color,
    required this.check,
    required this.onTap,
  }) : super(key: key);
  final String iconSrc, title;
  final Color color;
  final bool check;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50.h,
                width: 50.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(iconSrc),
              ),
              SizedBox(width: 11.w),
              SizedBox(
                child: Text(title, style: kText18Medium_14),
              ),
              Spacer(),
              if (check) (Icon(Icons.arrow_forward_ios, color: dtcolor1))
            ],
          ),
        ),
      ),
    );
  }
}
