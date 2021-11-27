import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/main.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: <Widget>[
                  ReturnButton(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Thông tin cá nhân',
                    textAlign: TextAlign.center,
                    style: titleText40,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Text(
                      'Vui lòng nhập chính xác thông tin cá nhân',
                      textAlign: TextAlign.center,
                      style: defaultText18.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(18),
                        color: loginSubTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Họ tên',
                          style: textfieldStyle,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày sinh',
                          style: textfieldStyle,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(
                                Icons.cake,
                                color: mainColor,
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: loginSubTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số điện thoại',
                          style: textfieldStyle,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: mainColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giới tính', style: textfieldStyle),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(
                                Icons.pending_outlined,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: mainColor,
                      ),
                      alignment: Alignment.center,
                      child: Text('HOÀN TẤT', style: buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
