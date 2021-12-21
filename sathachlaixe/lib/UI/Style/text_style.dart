import 'color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const fontFamily = "Roboto";

var kText40Bold_3 = kText30Bold_6.copyWith(
  color: dtcolor3,
  fontSize: ScreenUtil().setSp(40.sp),
);
var kText35Bold_1 = kText40Bold_3.copyWith(
  color: dtcolor1,
  fontSize: ScreenUtil().setSp(35.sp),
);
var kText35Bold_14 = kText40Bold_3.copyWith(
  color: dtcolor14,
  fontSize: ScreenUtil().setSp(35.sp),
);

var kText30Bold_14 = kText16Normal_14.copyWith(
  fontWeight: FontWeight.bold,
  fontSize: ScreenUtil().setSp(30.sp),
  color: dtcolor14,
);
var kText30Bold_6 = kText20Bold_13.copyWith(
    fontSize: ScreenUtil().setSp(30.sp), color: dtcolor6);

var kText28Bold_14 = kText30Bold_14.copyWith(
  fontSize: ScreenUtil().setSp(28.sp),
);
var kText24Normal_13 = kText22Bold_13.copyWith(
  fontWeight: FontWeight.normal,
  fontSize: ScreenUtil().setSp(24.sp),
);
var kText24Bold_13 = kText20Bold_13.copyWith(
  fontSize: ScreenUtil().setSp(24.sp),
);
var kText24Bold_14 = kText22Bold_14.copyWith(
  fontSize: ScreenUtil().setSp(24.sp),
);
var kText24Bold_1 = kText35Bold_1.copyWith(
  fontSize: ScreenUtil().setSp(24.sp),
);

var kText22Bold_13 = kText20Bold_13.copyWith(
  fontSize: ScreenUtil().setSp(22.sp),
);
var kText22Bold_14 = kText22Bold_13.copyWith(
  color: dtcolor14,
);

var kText22Medium_1 = kText20Medium_1.copyWith(
  fontSize: ScreenUtil().setSp(22.sp),
);
var kText22Medium_14 = kText22Medium_1.copyWith(
  color: dtcolor14,
);

var kText20Bold_13 = kText18Normal_14.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(20.sp),
    color: dtcolor13);
var kText20Bold_6 = kText30Bold_6.copyWith(fontSize: ScreenUtil().setSp(20.sp));

var kText20Medium_1 = kText16Normal_14.copyWith(
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(20.sp),
  color: dtcolor1,
);
var kText20Medium_10 = kText20Medium_1.copyWith(
  color: dtcolor10,
);
var kText20Medium_14 = kText20Medium_1.copyWith(
  color: dtcolor14,
);

var kText18Normal_14 =
    kText16Normal_14.copyWith(fontSize: ScreenUtil().setSp(18.sp));
var kText18Medium_13 = kText22Bold_13.copyWith(
  fontWeight: FontWeight.normal,
  fontSize: ScreenUtil().setSp(18.sp),
);
var kText18Bold_4 = kText18Bold_9.copyWith(color: dtcolor4);
var kText18Bold_9 =
    kText16Normal_14.copyWith(fontWeight: FontWeight.bold, color: dtcolor9);
var kText18Bold_3 =
    kText16Normal_14.copyWith(fontWeight: FontWeight.bold, color: dtcolor3);

var kText16Normal_14 = TextStyle(
    fontSize: ScreenUtil().setSp(16.sp),
    fontWeight: FontWeight.normal,
    color: dtcolor14,
    fontFamily: fontFamily);
var kText16Medium_13 = kText24Normal_13.copyWith(
  fontWeight: FontWeight.w400,
  fontSize: ScreenUtil().setSp(16.sp),
);
var kText16Normal_13 = kText16Normal_14.copyWith(color: dtcolor13);
var kText16Normal_11 = kText16Normal_14.copyWith(color: dtcolor11);
var kText16Medium_1 = kText20Medium_1.copyWith(
  fontSize: ScreenUtil().setSp(16.sp),
);

var kText16Normal_6 = kText16Normal_14.copyWith(
  color: dtcolor6,
);
var kText14Normal_10 = kText16Normal_14.copyWith(
  color: dtcolor10,
  fontSize: ScreenUtil().setSp(14.sp),
);
