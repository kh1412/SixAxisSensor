import 'dart:convert';
import 'dart:io';

import 'package:six_axis_sensor/data/local/sql/base.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase extends LocalBase {
  LocalDatabase({
    required super.dbname,
    required super.tablename,
    required super.tableJson,
  });

  @override
  Future<int> length() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query("select COUNT(*) from $tablename");
    return maps[0]['COUNT(*)'];
  }

  // データ追加
  @override
  Future<void> insert(List<Map<String, dynamic>> maps,
      {bool transaction = true}) async {
    final db = await database;

    if (transaction) {
      await db.transaction((txn) async {
        var batch = txn.batch();
        for (Map<String, dynamic> map in maps) {
          batch.insert(
            tablename,
            convertInput(map),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit();
      });
    } else {
      var batch = db.batch();
      for (Map<String, dynamic> map in maps) {
        batch.insert(
          tablename,
          convertInput(map),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    }
  }

  // 更新関数
  @override
  Future<void> update(
    Map<String, dynamic> map, // 更新するデータ
    dynamic colValue, // 指定する列の値
    {
    String colName = 'id', // 指定する列名
    bool insertIfAbsent = false, // 新規追加オプション
  }) async {
    final db = await database;

    String where = '$colName = ?';
    List<dynamic> whereArgs = [colValue];

    int affectedRows = await db.update(
      tablename,
      convertInput(map),
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    // 更新対象がない場合は新規追加
    if (affectedRows == 0 && insertIfAbsent) {
      await db.insert(
        tablename,
        convertInput(map),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // データ取得関数
  @override
  Future<List<Map<String, dynamic>>> select({
    Map? map, // 条件のキーと値
    int? limit, // 終了位置
    int offset = 0, // 開始位置のオフセット
    int? rangeStart, // 以上
    int? rangeEnd, // 以下
    String rangeCol = "time", // 以上・以下　条件に使う列名
    dynamic likeValue,
    String? likeCol,
    String orderByCol = "", // 並び替える列名
    bool descending = false, // 降順かどうか
  }) async {
    final db = await database;
    String sql = "select * from $tablename";

    if (map != null ||
        rangeStart != null ||
        rangeStart != null ||
        (likeValue != null && likeCol != null)) {
      sql += " where";
    }

    if (map != null) {
      map.forEach((key, value) => sql += " $key = '$value' and");
      sql = sql.substring(0, sql.length - 4);
    }

    sql += rangeStart != null ? " $rangeCol >= $rangeStart" : "";
    sql += (rangeStart != null && rangeEnd != null) ? " and" : "";
    sql += rangeEnd != null ? " $rangeCol <= $rangeEnd" : "";

    if (orderByCol.isNotEmpty) {
      sql += " ORDER BY $orderByCol";
      sql += descending ? " DESC" : " ASC";
    }

    sql += limit != null ? " limit ${limit - offset}" : "";
    sql += offset != 0 ? " offset $offset" : "";

    sql += (likeValue != null && likeCol != null)
        ? " $likeCol like %$likeValue%"
        : "";

    try {
      List<Map<String, dynamic>> jsons = convertOutput(await db.rawQuery(sql));
      return jsons;
    } catch (e) {
      return [];
    }
  }

  // データ削除関数
  @override
  Future<void> delete({
    Map? map, // 条件のキーと値
    int? limit, // 終了位置
    int offset = 0, // 開始位置のオフセット
    int? rangeStart, // 以上
    int? rangeEnd, // 以下
    String rangeCol = "time", // 以上・以下　条件に使う列名
  }) async {
    final db = await database;
    String sql = "delete from $tablename";

    if (map != null || rangeStart != null || rangeStart != null) {
      sql += " where";
    }

    if (map != null) {
      map.forEach((key, value) => sql += " $key = '$value' and");
      sql = sql.substring(0, sql.length - 4);
    }

    sql += rangeStart != null ? " $rangeCol >= $rangeStart" : "";
    sql += (rangeStart != null && rangeEnd != null) ? " and" : "";
    sql += rangeEnd != null ? " $rangeCol <= $rangeEnd" : "";

    sql += limit != null ? " limit ${limit - offset}" : "";
    sql += offset != 0 ? " offset $offset" : "";

    await db.rawQuery(sql);
  }

  // データファイル書き込み
  @override
  Future<bool> write(
    String filepath, // 出力先：ファイルパス
    int time, // 作成時間
    int limit, // データ数上限
  ) async {
    List<Map<String, dynamic>> data = await select(limit: limit, offset: 0);

    if (data.isEmpty) {
      return false;
    }

    Map<String, dynamic> json = {"created_at": time, "data": data};

    String encodeJson = const JsonEncoder().convert(json);
    List<int> jsonByte = utf8.encode(encodeJson);

    File file = File(filepath);
    await file.writeAsBytes(jsonByte);

    return true;
  }
}
