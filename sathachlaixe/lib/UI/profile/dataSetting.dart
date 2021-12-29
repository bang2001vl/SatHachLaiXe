import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Component/mode_item.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class DataSettingScreen extends StatelessWidget {
  bool status = true;

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 90.h,
                color: dtcolor1,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  children: <Widget>[
                    ReturnButton(),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Cài đặt dữ liệu",
                          style: kText20Bold_13,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    color: dtcolor13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hạng bằng lái xe',
                          style: kText18Bold_14,
                        ),
                        new CustomRadio(),
                        SyncSwitch(),
                        SizedBox(
                          height: 10.h,
                        ),
                        InkWell(
                            onTap: () {},
                            child: Text(
                              'Xóa và đặt lại dữ liệu',
                              style: kText18Bold_14.copyWith(color: dtcolor4),
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SyncSwitch extends StatefulWidget {
  @override
  _SyncSwitchState createState() => new _SyncSwitchState();
}

class _SyncSwitchState extends State<SyncSwitch> {
  bool syncStatus = false;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.only(top: 10.h),
      title: Text(
        'Đồng bộ hóa',
        style: kText18Bold_14,
      ),
      value: syncStatus,
      onChanged: (value) => setState(() {
        syncStatus = value;
      }),
    );
  }
}
