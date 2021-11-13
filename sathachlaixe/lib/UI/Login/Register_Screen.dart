import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
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
                children: <Widget>[
                  ReturnButton(),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    'Đăng ký',
                    textAlign: TextAlign.center,
                    style: titleText40,
                  ),
                  Text(
                    'Tạo tài khoản của bạn.',
                    textAlign: TextAlign.center,
                    style: loginSubTextColor,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  TextFieldContainer(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: cwColor5,
                        ),
                        hintText: "Email",
                        hintStyle: textfieldStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  TextFieldContainer(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: mainColor,
                        ),
                        hintText: "Mật khẩu",
                        hintStyle: textfieldStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  TextFieldContainer(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: cwColor5,
                        ),
                        hintText: "Nhập lại mật khẩu",
                        hintStyle: textfieldStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Bằng việc đăng ký, bạn đã đồng ý với ",
                      style: defaultText18.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(14),
                    ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Điều khoản dịch vụ ',
                          style: textfieldStyle.copyWith(
                            fontSize: ScreenUtil().setSp(14),
                          ),
                        ),
                        TextSpan(
                          text: 'và',
                          style: defaultText18.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(14),
                          ),
                        ),
                        TextSpan(
                          text: 'privacy notice',
                          style: kText14Medium_1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 72.h,
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
                        'REGISTER',
                        style: buttonText,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OtpScreen()));
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Đã có tài khoản?",
                        textAlign: TextAlign.center,
                        style: defaultText18,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Đăng ký',
                          style: defaultText20.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(18),
                            color: wrongAnsColor,
                          ),
                        ),
                      ),
                    ],
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
