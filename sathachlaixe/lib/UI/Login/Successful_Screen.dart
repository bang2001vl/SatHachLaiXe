import 'package:cowin_1/common/config/colors_config.dart';
import 'package:cowin_1/common/config/texts_config.dart';
import 'package:cowin_1/main.dart';
import 'package:cowin_1/views/login/profile_screen.dart';
import 'package:cowin_1/widget/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
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
                        'Registration Successful',
                        style: kTextConfig.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(22),
                          color: cwColor3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Welcome to Cowin',
                    textAlign: TextAlign.left,
                    style: kTextConfig.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(35),
                      color: cwColor1,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Update your profile to get news about\nCOVID-19 and the health care suggests\nmatching desires and your lifestyle!',
                    textAlign: TextAlign.left,
                    style: kTextConfig.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(18),
                      color: cwColor4,
                    ),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Image.asset(
                    'assets/images/Succesfull.png',
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
                        color: cwColor1,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'GET STARTED',
                        style: kTextConfig.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(20),
                          color: cwColor2,
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
