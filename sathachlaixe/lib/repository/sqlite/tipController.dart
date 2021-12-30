import 'package:sathachlaixe/model/tip.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class TipController implements TipRepo {
  final String tableName = "tips";

  Future<List<TipModel>> getTipAll() async {
    var db = await AppDBController().openDB();
    var mode = repository.getCurrentMode();
    String sql = "SELECT * FROM $tableName WHERE mode = ?";
    var reader = await db.rawQuery(sql, [mode]);
    return List<TipModel>.generate(reader.length, (i) {
      return TipModel.fromJSON(reader[i]);
    });
  }

  Future<List<TipModel>> getTipByType(int typeId) async {
    var db = await AppDBController().openDB();
    var mode = repository.getCurrentMode();
    String sql = "SELECT * FROM $tableName WHERE mode = ? AND typeId = ?";
    var reader = await db.rawQuery(sql, [mode, typeId]);
    return List<TipModel>.generate(reader.length, (i) {
      return TipModel.fromJSON(reader[i]);
    });
  }
}
