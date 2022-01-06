import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class UserAvatarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAvatarWidgetState();
  }
}

class _UserAvatarWidgetState extends State<UserAvatarWidget>
    with SocketObserver {
  UserModel? _userinfo;

  void onClick(context) {
    if (_userinfo == null) {
      repository.auth.showLogin(context);
    }
  }

  @override
  void initState() {
    super.initState();
    SocketBinding.instance.addObserver(this);
    setState(() {
      _userinfo = AppConfig.instance.userInfo;
    });
  }

  @override
  void onUserInfoChanged() {
    setState(() {
      _userinfo = AppConfig.instance.userInfo;
    });
  }

  @override
  void dispose() {
    SocketBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var defaultAvatar = Image.asset("assets/images/notUser.png");
    var avatar = defaultAvatar;
    bool isLogin = false;
    String name = "Khách";
    String phone = "Đăng nhập";
    if (_userinfo != null) {
      var userInfo = _userinfo as UserModel;
      isLogin = true;
      if (userInfo.hasImage) {
        var bytes = userInfo.rawimage!;

        avatar = Image.memory(
          Uint8List.fromList(bytes),
        );
      } else {
        avatar = Image.asset("assets/images/avtProfile.png");
      }
      name = userInfo.name;
      phone = userInfo.name;
    }

    return GestureDetector(
      onTap: () => onClick(context),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 20.h),
            child: ReturnButton(),
          ),
          SizedBox(
            height: 50.h,
          ),
          Container(
            height: 95.h,
            width: 95.h,
            child: Stack(children: [
              Center(
                child: CircleAvatar(
                  radius: 50.h,
                  backgroundImage: avatar.image,
                ),
              ),
              if (isLogin)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    height: 20.w,
                    width: 20.w,
                    child: SvgPicture.asset('assets/icons/photo.svg'),
                  ),
                ),
            ]),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            name,
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20.sp),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            phone,
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(14.sp),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
