import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import 'package:sathachlaixe/UI/Login/Register_Screen.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/widgets.dart' as wid;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/singleston/repository.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _needSaved = true;

  void onPressSubmit(context) async {
    log("Login with email : $_email, password : $_password");
    var result = await repository.auth
        .login(_email, _password, needSaveAuth: _needSaved);
    if (result == 1) {
      wid.Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (result == -1) {
      showNotifyMessage("Thất bại", "Không thể kết nối đến máy chủ");
    } else if (result == -402) {
      showNotifyMessage("Thất bại", "Sai email hoặc mật khẩu");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, right: 15.w),
          child: Column(
            children: [
              ReturnButton(),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 350.h,
                          child: Image.asset('assets/images/login.png'),
                        ),
                        Text('Đăng nhập',
                            textAlign: TextAlign.center, style: kText36Bold_3),
                        Text('Đăng nhập tài khoản của bạn.',
                            textAlign: TextAlign.center,
                            style: kText16Medium_10),
                        SizedBox(
                          height: 30.h,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 7.h),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Icon(
                                  Icons.person,
                                  color: dtcolor1,
                                ),
                              ),
                              hintText: "Email",
                              hintStyle: kText16Medium_1,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => _email = value,
                          ),
                        ),
                        SizedBox(
                          height: 17.h,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 7.h),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Icon(
                                  Icons.lock,
                                  color: dtcolor1,
                                ),
                              ),
                              hintText: "Mật khẩu",
                              hintStyle: kText16Medium_1,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => _password = value,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _needSaved,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _needSaved = newValue!;
                                      });
                                    },
                                  ),
                                  Text('Nhớ mật khẩu', style: kText14Normal_11),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassScreen()));
                                },
                                child: Text('Quên mật khẩu?',
                                    style: kText12Medium_1.copyWith(
                                        fontSize: 14.sp)),
                              ),
                            ],
                          ),
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
                              color: dtcolor1,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ĐĂNG NHẬP',
                              style: kText18Bold_13,
                            ),
                          ),
                          onTap: () {
                            onPressSubmit(context);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Chưa có tài khoản?",
                              textAlign: TextAlign.center,
                              style: kText14Bold_9,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text('Đăng ký!', style: kText14Bold_4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
