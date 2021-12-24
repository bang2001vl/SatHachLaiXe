import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sqflite/sqflite.dart';

import 'appController.dart';

class BoardController {
  final String tableName = 'board';

  BoardController() {}

  Future<BoardModel?> getBoard(int id) async {
    final db = await AppDBController().openDB();
    String sql = "SELECT * FROM $tableName WHERE id = ?";
    var reader = await db.rawQuery(sql, [id]);
    return reader.isEmpty ? null : BoardModel.fromJSON(reader.first);
  }

  Future<List<BoardModel>> getBoardByCate(int id) async {
    final db = await AppDBController().openDB();
    String sql = "SELECT * FROM $tableName WHERE cateId = ?";
    var reader = await db.rawQuery(sql, [id]);
    return List.generate(
        reader.length, (index) => BoardModel.fromJSON(reader[index]));
  }
}
