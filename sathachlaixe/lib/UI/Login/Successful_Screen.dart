import 'package:flutter_svg/flutter_svg.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: [
                  ReturnButton(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 15.h)),
                      SvgPicture.asset(
                        'assets/icons/success.svg',
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
                      fontSize: ScreenUtil().setSp(20),
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
                      height: 60.h,
                      width: 350.w,
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
                          color: Colors.white,
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
