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

class QuickTestScreen extends StatelessWidget {
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: Image.asset(
                      'assets/images/quicktest.png',
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Vui lòng chọn loại câu hỏi',
                      textAlign: TextAlign.center, style: kText16Medium_10),
                  SizedBox(
                    height: 30.h,
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
                      width: 250.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text('BẮT ĐẦU', style: kText20Bold_13),
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
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent))),
      value: selected,
      items: ["Tất cả"]
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
