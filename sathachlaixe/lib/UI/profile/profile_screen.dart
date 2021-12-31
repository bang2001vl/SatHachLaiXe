import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Component/profileMenuItem.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/profile/dataSetting.dart';
import 'package:sathachlaixe/UI/profile/mode_screen.dart';
import 'package:sathachlaixe/UI/profile/userWidget.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class PersonalScreen extends StatelessWidget {
  void onPressLogout() {
    repository.auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: 300.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cwcolor21,
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        'assets/images/profilebg.png',
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: UserAvatarWidget(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    Text(
                      'Cài đặt',
                      style: kText16Medium_1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(20.sp),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    ProfileMenuItem(
                      iconSrc: 'assets/icons/private.svg',
                      title: 'Thông tin cá nhân',
                      check: true,
                      color: cwcolor23,
                    ),
                    ProfileMenuItem(
                      iconSrc: "assets/icons/password.svg",
                      title: 'Đổi mật khẩu',
                      check: true,
                      color: cwcolor22,
                    ),
                    InkWell(
                      child: ProfileMenuItem(
                        iconSrc: 'assets/icons/security.svg',
                        title: 'Cài đặt dữ liệu',
                        check: true,
                        color: cwcolor24,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataSettingScreen()));
                      },
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Quy định và chính sách',
                      style: kText16Medium_1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(20.sp),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    ProfileMenuItem(
                      iconSrc: 'assets/icons/termOfUse.svg',
                      title: 'Quy định sử dụng',
                      check: true,
                      color: cwcolor24,
                    ),
                    ProfileMenuItem(
                      iconSrc: 'assets/icons/QA.svg',
                      title: 'Q&A',
                      check: false,
                      color: dtcolor7,
                    ),
                    ProfileMenuItem(
                      iconSrc: 'assets/icons/share.svg',
                      title: 'Chia sẻ ứng dụng',
                      check: false,
                      color: cwcolor25,
                    ),
                    GestureDetector(
                      child: ProfileMenuItem(
                        iconSrc: 'assets/icons/signout.svg',
                        title: 'Đăng xuất',
                        check: false,
                        color: cwcolor23,
                      ),
                      onTap: () => onPressLogout(),
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

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
