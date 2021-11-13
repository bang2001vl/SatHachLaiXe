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
import 'login_screen.dart';

class ForgotPassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 35.h,
                ),
                ReturnButton(),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'Forgot password',
                  textAlign: TextAlign.center,
                  style: kTextConfig.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(40),
                    color: cwColor1,
                  ),
                ),
                Text(
                  'Enter the Email/ Phone number associated\nwith your account and we’ll send an email\nwith instruction to reset your password',
                  textAlign: TextAlign.left,
                  style: kTextConfig.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(18),
                    color: cwColor4,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 36.h, vertical: 5.h),
                //   child: TextFieldWidget(
                //     label: 'Email/ Phone number',
                //   ),
                // ),
                 Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 36.h, vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email/ Phone number',
                        style: kTextConfig.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(15),
                          color: cwColor1,
                        ),
                      ),
                      SizedBox(
                        height: 11.h,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: cwColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 55.h,
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
                      'SEND OTP',
                      style: kTextConfig.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(20),
                        color: cwColor2,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
