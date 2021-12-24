import 'dart:developer';

import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sqflite/sqflite.dart';

import 'appController.dart';

class BoardCateController {
  final String tableName = 'boardCate';

  BoardCateController() {}

  Future<BoardCategoryModel?> getBoardCate(int id) async {
    final db = await AppDBController().openDB();
    String sql = "SELECT * FROM $tableName WHERE id = ?";
    var reader = await db.rawQuery(sql, [id]);
    return reader.isEmpty ? null : BoardCategoryModel.fromJSON(reader.first);
  }

  Future<List<BoardCategoryModel>> getBoardCateAll() async {
    final db = await AppDBController().openDB();
    String sql = "SELECT * FROM $tableName";
    var reader = await db.rawQuery(sql);
    return List.generate(
        reader.length, (index) => BoardCategoryModel.fromJSON(reader[index]));
  }
}
