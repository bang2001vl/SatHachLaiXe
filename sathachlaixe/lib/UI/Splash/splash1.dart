import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/themes.dart';
import 'package:sathachlaixe/UI/Home/home_screen.dart';
import 'package:sathachlaixe/UI/Login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sathachlaixe/UI/Style/size.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: dtcolor2,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 94.w),
              child: Column(
                children: [
                  Text(
                    "Skip",
                    textAlign: TextAlign.right,
                    style: kText18Medium_1,
                  ),
                  Image.asset(
                    'assets/image/splash1.png',
                    height: 361.h,
                    width: 250.w,
                  ),
                  Text("Ôn thi lý thuyết.",
                      textAlign: TextAlign.left, style: kText26Bold_6),
                  SizedBox(
                    height: 69.h,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: Text('CONTINUE', style: kText12Medium_13),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen2()));
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

class SplashScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: dtcolor9,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 94.h),
              child: Column(
                children: [
                  Text("Take care of health...",
                      textAlign: TextAlign.left, style: kText18Bold_13),
                  SizedBox(
                    height: 69.h,
                  ),
                  Image.asset(
                    'assets/image/splash2.png',
                    height: 334.h,
                    width: 364.h,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'CONTINUE',
                        style: kText16Medium_1.copyWith(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen3()));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    },
                    child: Text(
                      'Skip',
                      style: kText16Medium_1.copyWith(
                          color: Colors.white, fontSize: 14),
                    ),
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

class SplashScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: dtcolor9,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 94.h),
              child: Column(
                children: [
                  Text(
                    "Take care of health...",
                    textAlign: TextAlign.left,
                    style: kText16Medium_1.copyWith(
                        color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(
                    height: 69.h,
                  ),
                  Image.asset(
                    'assets/image/splash3.png',
                    height: 334.h,
                    width: 364.h,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'CONTINUE',
                        style: kText20Bold_13.copyWith(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen4()));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen2()));
                    },
                    child: Text(
                      'Skip',
                      style: kText16Medium_1.copyWith(
                          color: Colors.white, fontSize: 14),
                    ),
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

class SplashScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: dtcolor1,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 90.h),
              child: Column(
                children: [
                  Text(
                    "Welcome to COWIN",
                    textAlign: TextAlign.center,
                    style: kText16Medium_1.copyWith(
                        color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    "Stay safe and get up to dates announcement city authorities.",
                    textAlign: TextAlign.center,
                    style: kText16Medium_1.copyWith(
                        color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Image.asset(
                    'assets/images/splash4.png',
                    height: 334.h,
                    width: 364.h,
                  ),
                  SizedBox(
                    height: 65.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'GET START',
                        style: kText16Medium_1.copyWith(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: dtcolor1,
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
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
