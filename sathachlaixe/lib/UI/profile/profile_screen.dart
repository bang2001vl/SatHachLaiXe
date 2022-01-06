import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Component/profileMenuItem.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Login/profile_screen.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/profile/dataSetting.dart';
import 'package:sathachlaixe/UI/profile/menuWidget.dart';
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
            Expanded(
              child: MenuWidget(),
            )
          ],
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
