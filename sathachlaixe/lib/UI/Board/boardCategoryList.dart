import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/ques_category.dart';
import 'package:sathachlaixe/UI/Component/test.dart';
import 'package:sathachlaixe/UI/Component/testUnStarted.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/UI/studyQues/studyQuiz_screen.dart';
import 'package:sathachlaixe/bloc/categoteryBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class QuesCategoryScreen extends StatelessWidget {
  final List<QuestionCategoryModel> catagories;
  final Function(QuestionCategoryModel item)? onClickItem;
  QuesCategoryScreen(
    this.catagories, {
    this.onClickItem,
    Key? key,
  }) : super(key: key);

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
              Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 15.h, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ReturnButton(),
                    Text('CÁC LOẠI BIỂN BÁO', style: kText24Bold_14),
                    IconButton(
                      onPressed: () {},
                      iconSize: 35.h,
                      icon: SvgPicture.asset('assets/icons/shuffle.svg'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: dtcolor16,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    child: ListView.builder(
                      itemCount: this.catagories.length,
                      itemBuilder: (context, index) =>
                          buildItem(context, this.catagories[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, QuestionCategoryModel categoryModel) {
    return FutureBuilder<int>(
        future: categoryModel.countHasComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var countComplete = snapshot.data as int;
            return InkWell(
              child: QuesCategoryItem(
                  imageSrc: categoryModel.assetURL!,
                  name: categoryModel.name,
                  subtitle: categoryModel.detail,
                  totalQues: categoryModel.length,
                  correctQues: countComplete),
              onTap: () => this.onClickItem?.call(categoryModel),
            );
          }

          if (snapshot.hasError) {
            return buildError(context, snapshot.error);
          }

          return buildLoading(context);
        });
  }
}
