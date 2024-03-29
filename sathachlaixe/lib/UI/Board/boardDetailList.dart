import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Board/boardFlipCard.dart';
import 'package:sathachlaixe/UI/Board/boardPlay.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/board_category.dart';
import 'package:sathachlaixe/UI/Component/board_item.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/bloc/boadCategoryBloc.dart';
import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardDetailScreen extends StatelessWidget {
  final BoardCategoryModel cate;
  BoardDetailScreen({required this.cate, Key? key}) : super(key: key);
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
                    right: 20.w, top: 20.h, left: 15.w, bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ReturnButton(),
                    Text(
                      cate.name,
                      style: kText20Bold_14,
                    ),
                    InkWell(
                      child: Container(
                        height: 25.h,
                        width: 25.h,
                        child: SvgPicture.asset('assets/icons/playBlack.svg'),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoardPlayScreen(
                                      cate: cate,
                                    )));
                      },
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
    return FutureBuilder<List<BoardModel>>(
        future: cate.getChilds(),
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
  Widget buildContent(context, List<BoardModel> boards) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) => buildItem(context, boards[index]),
      ),
    );
  }

  Widget buildItem(BuildContext context, BoardModel boardsModel) {
    {
      return InkWell(
        child: BoardItem(
          imageSrc: boardsModel.assetURL,
          name: boardsModel.name,
          subtitle: boardsModel.detail,
        ),
        onTap: () {},
      );
    }
  }
}
