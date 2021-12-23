import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Board/boardDetailList.dart';
import 'package:sathachlaixe/UI/Component/board_category.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/bloc/boadCategoryBloc.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardCategoryScreen extends StatelessWidget {
  _onClickedItem(BuildContext context, BoardCategoryModel item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BoardDetailScreen(
                  cate: item,
                ))).then(
        (value) => BlocProvider.of<BoardCategoteryBloc>(context).reload());
  }

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
                    Text('CÁC LOẠI BIỂN BÁO', style: kText20Bold_14),
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
                    child: BoardCategoryScreenWithFuture(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BoardCategoryScreenWithFuture(BuildContext context) {
    return FutureBuilder<List<BoardCategoryModel?>>(
        future: repository.getBoardCategory(),
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
  Widget buildContent(context, List<BoardCategoryModel?> catagories) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: ListView.builder(
        itemCount: catagories.length,
        itemBuilder: (context, index) => buildItem(context, catagories[index]!),
      ),
    );
  }

  Widget buildItem(BuildContext context, BoardCategoryModel categoryModel) {
    {
      return InkWell(
        child: BoardCategoryItem(
          imageSrc: categoryModel.assetURL,
          name: categoryModel.name,
          subtitle: categoryModel.detail,
        ),
        onTap: () => _onClickedItem(context, categoryModel),
      );
    }
  }
}
