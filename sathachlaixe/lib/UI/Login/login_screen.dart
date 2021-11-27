import 'dart:ffi';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import 'Register_Screen.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.h),
                  child: Image.asset('assets/images/login.png'),
                ),
                Text('Đăng nhập',
                    textAlign: TextAlign.center, style: titleText40),
                Text(
                  'Đăng nhập tài khoản của bạn.',
                  textAlign: TextAlign.center,
                  style: defaultText20.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(20),
                    color: loginSubTextColor,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                TextFieldContainer(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: mainColor,
                      ),
                      hintText: "Email",
                      hintStyle: textfieldStyle,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                TextFieldContainer(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
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
                  height: 10.h,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                    Text(
                      'Nhớ mật khẩu',
                    ),
                    SizedBox(
                      width: 100.w,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassScreen()));
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: textfieldStyle.copyWith(
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                GestureDetector(
                  child: Container(
                    height: 60.h,
                    width: 340.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      color: mainColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ĐĂNG NHẬP',
                      style: buttonText,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chưa có tài khoản?",
                      textAlign: TextAlign.center,
                      style: defaultText18,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        'Đăng ký!',
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
          ],
        ),
      ),
    );
  }
}
