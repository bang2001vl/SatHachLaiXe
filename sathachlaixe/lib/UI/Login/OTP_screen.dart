import 'dart:ffi';

import 'package:cowin_1/common/config/colors_config.dart';
import 'package:cowin_1/common/config/texts_config.dart';
import 'package:cowin_1/themes.dart';
import 'package:cowin_1/views/login/widgets/textfield.dart';
import 'package:cowin_1/widget/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../size_config.dart';
import 'Successful_Screen.dart';
import 'login_screen.dart';

class OtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 25.w),
              child: Column(
                children: [
                  ReturnButton(),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    'Verification code',
                    textAlign: TextAlign.center,
                    style: kTextConfig.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(40),
                      color: cwColor1,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Enter the OTP has been sent to',
                    textAlign: TextAlign.center,
                    style: kTextConfig.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(20),
                      color: cwColor4,
                    ),
                  ),
                  Text(
                    "******5945",
                    textAlign: TextAlign.center,
                    style: kTextConfig.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(28),
                      color: cwColor3,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldOTP(),
                        TextFieldOTP(),
                        TextFieldOTP(),
                        TextFieldOTP(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t receive OTP?",
                        textAlign: TextAlign.center,
                        style: kTextConfig.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(18),
                          color: cwColor4,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'RESENT OTP (112)',
                          style: kTextConfig.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(18),
                            color: cwColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 61.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: cwColor1,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'VERIFY',
                        style: kTextConfig.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(20),
                          color: cwColor2,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessfulScreen()));
                    },
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

class TextFieldOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86.h,
      width: 58.w,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          showCursor: false,
          readOnly: false,
          style: kTextConfig.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(35),
            color: cwColor1,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: cwColor5),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
