import 'dart:math';

import 'package:sathachlaixe/UI/Component/ques_category.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/studyQues/studyQuiz_screen.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class QuickTestScreen extends StatelessWidget {
  QuestionCategoryModel? selected;
  final int count = 5;

  void onClickSubmit(context) async {
    if (selected == null) return;
    int c = count;
    var questionIds = List.of(selected!.questionIDs);
    if (c > questionIds.length) {
      c = questionIds.length;
    }

    // Add by wrong times
    var p = await repository
        .getPracticeList(questionIds.map((e) => int.parse(e)).toList());
    for (var item in p) {
      for (var i = 0; i < item.countWrong; i++) {
        questionIds.add(item.questionID.toString());
      }
    }
    // Shuffle
    questionIds.shuffle(Random(DateTime.now().millisecondsSinceEpoch));

    // Select
    var selectedList = List<String>.empty(growable: true);
    for (int i = 0; i < questionIds.length && selectedList.length < c; i++) {
      var id = questionIds[i];
      // Prevent duplicate
      while (i < questionIds.length && selectedList.contains(id)) {
        i++;
        id = questionIds[i];
      }
      selectedList.add(id);
    }

    // Sort
    selectedList.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizStudyScreen.modePratice(selectedList),
        ));
  }

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
                    child: new MyDropDown(
                      onSelect: (p0) => this.selected = p0,
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  GestureDetector(
                    onTap: () => onClickSubmit(context),
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
  final Function(QuestionCategoryModel)? onSelect;
  MyDropDown({this.onSelect, Key? key}) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  late String selected;

  late List<QuestionCategoryModel> cates;

  String getValue(QuestionCategoryModel cate) {
    return cate.name;
  }

  @override
  void initState() {
    cates = repository.getQuestionCategory();
    selected = getValue(cates[0]);
    super.initState();
    widget.onSelect?.call(cates[0]);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent))),
      value: selected,
      items: List.generate(cates.length, (index) {
        var name = cates[index].name;
        var value = getValue(cates[index]);

        return DropdownMenuItem(
          child: Text(
            name,
            style: kText16Medium_1,
          ),
          value: value,
        );
      }),
      onChanged: (value) {
        setState(() => selected = value!);
        widget.onSelect
            ?.call(cates.where((cate) => getValue(cate) == value).first);
      },
    );
  }
}
