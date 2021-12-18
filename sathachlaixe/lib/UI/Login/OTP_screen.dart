import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: [
                  ReturnButton(),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Mã xác thực',
                    textAlign: TextAlign.center,
                    style: kText40Bold_3,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text('Mã xác thực được gửi đến',
                      textAlign: TextAlign.center, style: kText20Medium_10),
                  Text("******5945",
                      textAlign: TextAlign.center, style: kText28Bold_14),
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
                        "Chưa nhận được mã?",
                        textAlign: TextAlign.center,
                        style: kText18Bold_9.copyWith(
                          fontSize: ScreenUtil().setSp(17),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('GỬI LẠI (112)', style: kText18Bold_3),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 61.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 350.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'XÁC NHẬN',
                        style: kText22Bold_13,
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
          style: kText35Bold_1,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: dtcolor3),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
