import 'dart:convert';
import 'dart:ffi';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

abstract class LocalBase {
  final String dbname;
  final String tablename;
  final Map<String, dynamic> tableJson;
  Database? _database;

  String sqlCreateTable = "";
  String path = "";

  // データ数取得
  Future<int> length();

  // データ追加
  Future<void> insert(List<Map<String, dynamic>> maps);

  // 更新関数
  Future<void> update(
    Map<String, dynamic> map,
    dynamic colValue, {
    String colName = 'id',
  });

  // 取り出し
  Future<List<Map<String, dynamic>>> select({
    Map? map, // 条件のキーと値
    int? limit, // データ数上限
    int offset = 0, // 開始位置のオフセット
    int? rangeStart, // 以上
    int? rangeEnd, // 以下
    String rangeCol = "time", // 以上・以下　条件に使う列名
    dynamic likeValue,
    String? likeCol,
  });

  // 削除
  Future<void> delete({
    Map? map, // 条件のキーと値
    int? limit, // 終了位置
    int offset = 0, // 開始位置のオフセット
    int? rangeStart, // 以上
    int? rangeEnd, // 以下
    String rangeCol = "time", // 以上・以下　条件に使う列名
  });

  // データファイル書き込み
  Future<void> write(String filepath, int time, int limit);

  LocalBase({
    required this.dbname,
    required this.tablename,
    required this.tableJson,
  });

  // 初期化
  Future<void> init() async {
    // データベースファイルのパスを取得
    path = join(await getDatabasesPath(), dbname);
    sqlCreateTable = _jsonTosql(tableJson);
    await _checkTable();
  }

  /// insert・update時に型チェック
  Map<String, dynamic> convertInput(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = {};
    for (var key in map.keys) {
      switch (map[key].runtimeType) {
        case const (bool):
          newMap[key] = map[key] == true ? 1 : -1;
          break;
        case const (String):
        case const (double):
        case const (Double):
        case const (Float):
        case const (int):
          newMap[key] = map[key];
          break;
        default:
          newMap[key] = _encoder(map[key]);
      }
    }
    return newMap;
  }

  String _encoder(dynamic value) {
    return jsonEncode(value);
  }

  /// 出力用に変換関数
  List<Map<String, dynamic>> convertOutput(List<Map<String, dynamic>> maps) {
    List<Map<String, dynamic>> newMaps = [];
    for (var map in maps) {
      Map<String, dynamic> newMap = {};
      for (var key in tableJson.keys) {
        switch (tableJson[key].runtimeType) {
          case const (String):
          case const (int):
          case const (Float):
          case const (double):
          case const (Double):
            newMap[key] = map[key];
            break;
          case const (bool):
            newMap[key] = map[key] == 1 ? true : false;
            break;
          default:
            newMap[key] = jsonDecode(map[key]);
        }
      }
      newMaps.add(newMap);
    }
    return newMaps;
  }

  /// 型をsqlの型に変換
  String _convertType(dynamic value) {
    switch (value.runtimeType) {
      case const (int):
        return "INT";
      case const (String):
        return "TEXT";
      case const (Float):
        return "REAL";
      case const (double):
        return "REAL";
      case const (Double):
        return "REAL";
      case const (bool):
        return "INT";
      default:
        return "TEXT";
    }
  }

  // insert, update時の型チェック

  // json -> sql
  // Map から String に変換
  String _jsonTosql(Map json) {
    String sql = "CREATE TABLE $tablename (";
    tableJson.forEach((key, value) {
      sql += "$key $value,";
    });
    sql = sql.substring(0, sql.length - 1);
    sql += ")";
    return sql;
  }

  Future<void> _checkTable() async {
    Database db = await database;
    List<Map<String, Object?>> maps = await db.rawQuery(
      "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='$tablename'",
    );

    // databaseが無い時は作成
    if (maps[0].values.first == 0) {
      await db.execute(sqlCreateTable);
    }

    // テーブルアップデート
    await updateTable(tableJson);
  }

  // テーブルアップデート関数
  updateTable(Map<String, dynamic> json) async {
    // データをバックアップ
    List<Map<String, dynamic>> dumps = [];

    // テーブルの列を追加
    Database db = await database;

    // tableの情報取得
    List<Map<String, dynamic>> maps =
        await db.rawQuery("pragma table_info($tablename)");

    // 列名取得
    Map<String, dynamic> cols = {};
    for (Map<String, dynamic> col in maps) {
      cols[col["name"]] = col["type"];
    }

    // json key取得
    for (String col in json.keys) {
      String sqlColType = _convertType(json[col]);
      // 列が存在しない場合
      if (!cols.keys.contains(col)) {
        if (dumps.isEmpty) {
          dumps = await select();
          await delete();
        }

        try {
          await db.rawQuery("alter table $tablename add $col $sqlColType");
        } catch (_) {} // 二重で列作成をしそうになった時
      } else {
        // 型チェック
        if (sqlColType != cols[col]) {
          if (dumps.isEmpty) {
            dumps = await select();
            await delete();
          }
          DateTime now = DateTime.now();
          DateFormat outputFormat = DateFormat('yyyyMMdd_Hm');
          String date = outputFormat.format(now);

          String newCol = "${col}_$date";

          // dumpsのkeyを変更
          List<Map<String, dynamic>> convertKeyDumps = [];
          for (var dump in dumps) {
            Map<String, dynamic> row = {...dump}; // read only 回避
            row[newCol] = dump[col]; // 新しい列名でvalueをセット
            row.remove(col); // 古い列を削除
            convertKeyDumps.add(row);
          }
          // dumpsを置き換え
          dumps = convertKeyDumps;

          // 列名変更
          await db
              .rawQuery("ALTER TABLE $tablename RENAME COLUMN $col TO $newCol");
          // 新しい型で追加
          await db.rawQuery("alter table $tablename add $col $sqlColType");
        }
      }
    }
    // データ復旧
    if (dumps.isNotEmpty) {
      await insert(dumps);
    }
  }

  // データベース接続関数
  Future<Database> get database async {
    if (_database != null) return _database!;
    final String path = join(await getDatabasesPath(), dbname);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(sqlCreateTable);
      },
    );
    return _database!;
  }
}
