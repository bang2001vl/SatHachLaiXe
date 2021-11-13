import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 25.w),
              child: Column(
                children: [
                  ReturnButton(),
                  SizedBox(
                    height: 45.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 15.h)),
                      Image.asset(
                        'assets/icons/success.png',
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Text(
                        'Đăng ký thành công!',
                        style: defaultText20.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(22),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Chào mừng bạn đến \n với E-Drive',
                    textAlign: TextAlign.left,
                    style: defaultText20.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(35),
                      color: mainColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Cập nhật thông tin cá nhân để có trải\nnghiệm tốt nhất!',
                    textAlign: TextAlign.left,
                    style: defaultText20.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(18),
                      color: loginSubTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Image.asset(
                    'assets/images/successful.png',
                    height: 352.h,
                    width: 412.h,
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: mainColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'BẮT ĐẦU',
                        style: defaultText20.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(20),
                          color: mainColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
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
