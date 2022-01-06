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
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
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
                    'Thông tin cá nhân',
                    textAlign: TextAlign.center,
                    style: kText36Bold_3.copyWith(fontSize: 32.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Text(
                        'Vui lòng nhập chính xác thông tin cá nhân',
                        textAlign: TextAlign.center,
                        style: kText16Medium_10),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Họ tên',
                          style: kText16Medium_1,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(Icons.person, color: dtcolor1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày sinh',
                          style: kText16Medium_1,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        BirthdayDateTimePicker(
                          defaultDate: DateTime.now(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: kText16Medium_1,
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          height: 55.h,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: dtcolor1,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giới tính', style: kText16Medium_1),
                        SizedBox(
                          height: 11.h,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: dtcolor11, width: 1.w),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.pending_outlined,
                                color: dtcolor1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: new MyDropDown(
                                    defaultSelected: 'Nam',
                                    onSelectItem: (item) {
                                      this.value = item;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 280.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: dtcolor1,
                      ),
                      alignment: Alignment.center,
                      child: Text('CẬP NHẬT', style: kText20Bold_13),
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

class BirthdayDateTimePicker extends StatefulWidget {
  final DateTime defaultDate;
  BirthdayDateTimePicker({
    required this.defaultDate,
    Key? key,
  }) : super(key: key);

  @override
  _BirthdayDateTimePickerState createState() =>
      _BirthdayDateTimePickerState(defaultDate: defaultDate);
}

class _BirthdayDateTimePickerState extends State<BirthdayDateTimePicker> {
  _BirthdayDateTimePickerState({required this.defaultDate});
  DateTime defaultDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: dtcolor11, width: 1.w),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 55.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cake,
            color: dtcolor1,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                '${defaultDate.day}/${defaultDate.month}/${defaultDate.year}',
                style: kText16Normal_11,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: defaultDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now());
              if (newDate != null)
                setState(() {
                  defaultDate = newDate;
                });
            },
            child: Icon(
              Icons.calendar_today_outlined,
              color: dtcolor10,
            ),
          )
        ],
      ),
    );
  }
}

class MyDropDown extends StatefulWidget {
  final String defaultSelected;
  final Function(String? item)? onSelectItem;
  MyDropDown({
    required this.defaultSelected,
    this.onSelectItem,
    Key? key,
  }) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState(selected: defaultSelected);
}

class _MyDropDownState extends State<MyDropDown> {
  _MyDropDownState({required this.selected});
  String selected;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      items: ["Nam", "Nữ"]
          .map((label) => DropdownMenuItem(
                child: Text(
                  label,
                  style: kText16Normal_11,
                ),
                value: label,
              ))
          .toList(),
      onChanged: (value) {
        widget.onSelectItem?.call(value);
        setState(() => selected = value!);
      },
    );
  }
}
