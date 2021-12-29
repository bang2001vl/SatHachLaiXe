import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Board/boardDetailList.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/board_category.dart';
import 'package:sathachlaixe/UI/Component/tipPrac_item.dart';
import 'package:sathachlaixe/UI/Component/tip_item.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/bloc/boadCategoryBloc.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/tip.dart';
import 'package:sathachlaixe/repository/sqlite/tipController.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class PracticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TipModel?>>(
        future: repository.getTipsByType(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            //log("has data");
            return buildContent(context, snapshot.data!);
          }

          if (snapshot.hasError) {
            return Text("Có lỗi xảy ra!");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget buildContent(context, List<TipModel?> tips) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        left: 20.w,
        right: 15.w,
      ),
      child: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) => buildItem(context, tips[index]!),
      ),
    );
  }

  Widget buildItem(BuildContext context, TipModel tipModel) {
    {
      return TipPracItem(
        title: tipModel.title,
        content: tipModel.contentList,
        count: tipModel.count,
      );
    }
  }
}
