import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  'Quên mật khẩu',
                  textAlign: TextAlign.center,
                  style: titleText40,
                ),
                Text(
                  'Nhập email bạn đã đăng ký.',
                  textAlign: TextAlign.left,
                  style: defaultText20.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(18),
                    color: loginSubTextColor,
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
                        'Email',
                        style: textfieldStyle
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
                            color: mainColor,
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
                      color: mainColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'GỬI OTP',
                      style: buttonText
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
