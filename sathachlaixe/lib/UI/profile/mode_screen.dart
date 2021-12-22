import 'dart:ffi';

import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/main.dart';

class ModeScreen extends StatelessWidget {
  final items = ['B1', 'B2'];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
              child: Column(
                children: <Widget>[
                  ReturnButton(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Chọn loại bằng lái',
                    textAlign: TextAlign.center,
                    style: kText36Bold_3,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Text('Vui lòng chọn loại bằng lái bạn muốn ôn thi!',
                        textAlign: TextAlign.center, style: kText16Medium_10),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Image.asset(
                    'assets/images/mode.png',
                    width: double.infinity,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    width: 250.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: dtcolor1, width: 2.w),
                    ),
                    child: new MyDropDown(),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 320.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text('XÁC NHẬN', style: kText20Bold_13),
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

class MyDropDown extends StatefulWidget {
  MyDropDown();

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String? selected;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      items: ["B1", "B2"]
          .map((label) => DropdownMenuItem(
                child: Text(
                  label,
                  style: kText16Medium_1,
                ),
                value: label,
              ))
          .toList(),
      onChanged: (value) {
        setState(() => selected = value!);
      },
    );
  }
}
