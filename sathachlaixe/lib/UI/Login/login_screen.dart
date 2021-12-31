import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/widgets.dart' as wid;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'Register_Screen.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  String _email = '';
  String _password = '';
  bool _needSaved = true;

  void onPressSubmit(context) async {
    log("Login with email : $_email, password : $_password");
    var result = await repository.auth
        .login(_email, _password, needSaveAuth: _needSaved);
    if (result == 1) {
      wid.Navigator.pop(context, "OK");
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
                    textAlign: TextAlign.center, style: kText36Bold_3),
                Text('Đăng nhập tài khoản của bạn.',
                    textAlign: TextAlign.center, style: kText16Medium_10),
                SizedBox(
                  height: 30.h,
                ),
                TextFieldContainer(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: dtcolor1,
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: dtcolor1,
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
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Checkbox(
                      value: _needSaved,
                      onChanged: (value) {
                        _needSaved = value!;
                      },
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
                      child: Text('Quên mật khẩu?', style: kText16Medium_1),
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
                                builder: (context) => RegisterScreen()));
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
    );
  }
}
