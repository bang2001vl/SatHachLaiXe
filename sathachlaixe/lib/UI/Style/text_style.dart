import 'color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const fontFamily = "Roboto";

var defaultText20 = TextStyle(
    fontSize: ScreenUtil().setSp(20),
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: fontFamily);

var defaultText18 = defaultText20.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(18),
    color: splashTextColor);

var titleText40 = defaultText20.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(40),
    color: mainColor);
var titleText30 = defaultText20.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(30),
    color: titleColor);

var textfieldStyle = defaultText20.copyWith(
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(16),
  color: mainColor,
);
var buttonText = defaultText20.copyWith(
  fontWeight: FontWeight.bold,
  fontSize: ScreenUtil().setSp(20),
  color: Colors.white,
);
