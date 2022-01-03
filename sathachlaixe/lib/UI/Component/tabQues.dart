import 'package:sathachlaixe/UI/Component/quesContainer.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/model/practice.dart';

class BoardCategoryItem extends StatelessWidget {
  const BoardCategoryItem({
    Key? key,
    required this.listQues,
  }) : super(key: key);
  final List<PracticeModel> listQues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            childAspectRatio: 1 / 1,
          ),
          itemCount: listQues.length,
          itemBuilder: (BuildContext context, index) {
            return QuesContainerItem(
                index: index + 1,
                correct: listQues[index].correctAnswer,
                selected: listQues[index].selectedAnswer);
          }),
    );
  }
}
