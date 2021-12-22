import 'dart:ffi';

import 'package:sathachlaixe/UI/Login/OTP_screen.dart';
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: <Widget>[
                  ReturnButton(),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Quên mật khẩu',
                    textAlign: TextAlign.center,
                    style: kText36Bold_3,
                  ),
                  Text('Nhập email bạn đã đăng ký.',
                      textAlign: TextAlign.left, style: kText16Medium_10),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: kText16Medium_1),
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
                              color: dtcolor1,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 55.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 340.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text('GỬI OTP', style: kText18Bold_13),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OtpScreen()));
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
