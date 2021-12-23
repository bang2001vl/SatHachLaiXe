import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OTP_screen.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: <Widget>[
                  ReturnButton(),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    'Đăng ký',
                    textAlign: TextAlign.center,
                    style: kText36Bold_3,
                  ),
                  Text('Tạo tài khoản của bạn.',
                      textAlign: TextAlign.center, style: kText16Medium_10),
                  SizedBox(
                    height: 40.h,
                  ),
                  TextFieldContainer(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: dtcolor3,
                        ),
                        hintText: "Email",
                        hintStyle: kText16Medium_1,
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
                          color: dtcolor1,
                        ),
                        hintText: "Mật khẩu",
                        hintStyle: kText16Medium_1,
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
                          color: dtcolor3,
                        ),
                        hintText: "Nhập lại mật khẩu",
                        hintStyle: kText16Medium_1,
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
                      text: "Bằng việc đăng ký, bạn đã đồng ý với\n",
                      style: kText10Normal_10,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Điều khoản dịch vụ ',
                          style: kText16Medium_1.copyWith(
                            fontSize: ScreenUtil().setSp(14),
                          ),
                        ),
                        TextSpan(
                          text: 'và ',
                          style: kText10Normal_10,
                        ),
                        TextSpan(
                            text: 'Chính sách riêng tư',
                            style: kText10Normal_10),
                        TextSpan(
                          text: '\n của chúng tôi.',
                          style: kText10Normal_10,
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
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ĐĂNG KÝ',
                        style: kText20Bold_13,
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
                        style: kText14Bold_9,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text('Đăng nhập', style: kText14Bold_4),
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
