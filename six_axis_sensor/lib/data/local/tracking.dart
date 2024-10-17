import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:six_axis_sensor/data/local/sql/local_database.dart';
import 'package:six_axis_sensor/data/model/accelerometerData.dart';

class TrackingLocal {
  String dbnameTracking = 'tracking.db';
  late final LocalDatabase _accelTrackingTable = LocalDatabase(
    dbname: dbnameTracking,
    tablename: 'accelTracking',
    tableJson: AccelerometerData().toJson(),
  );

  final int batchN = 100;
  final int accuracyOrder = 4; // 加速度の桁数をどこまで取るか
  int accuracyOrderValue = 10000; // 加速度の桁数を丸めるための値
  final List<Map<String, dynamic>> batchMaps = [];

  // アプリ起動後に
  Future<void> init() async {
    await _accelTrackingTable.init();

    accuracyOrderValue = pow(10, accuracyOrder).toInt();
  }

  // データ追加
  Future<void> insert(AccelerometerData data) async {
    batchMaps.add(data.toJson());

    // バッチ数が一定数に達したらデータを追加
    if (batchMaps.length >= batchN) {
      await _accelTrackingTable.insert(batchMaps, transaction: false);
      batchMaps.clear();
    }
  }

  // ファイルに書き込み
  Future<void> writeFile({
    String log = "",
    List<String>? jsonFilenames, // 追加するjsonファイル名
    List<Map<String, dynamic>>? jsons, // 追加するjsonデータ
  }) async {
    int accelLength = await _accelTrackingTable.length();
    if (accelLength == 0) return;

    final accels = await _accelTrackingTable.select();

    // ファイル出力
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory chaceDir = await getTemporaryDirectory();
    Directory trackingDir = Directory('${appDocDir.path}/tracking');
    if (!await trackingDir.exists()) {
      await trackingDir.create(recursive: true);
    }

    int now = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> trackingData = {
      'createdAt': now,
      'accelLength': accelLength,
      'log': log,
      'data': {
        'accel': accels,
      }
    };

    String jsonStr = json.encode(trackingData); // json文字列に変換
    String jsonFilepath = "${chaceDir.path}/$now.json"; // jsonファイルのパス
    File jsonFile = File(jsonFilepath); // jsonファイルの作成
    await jsonFile.writeAsString(jsonStr); // jsonファイルに書き込み

    await _accelTrackingTable.delete(); // テーブル削除
  }

  // データ削除
  Future<void> delete() async {
    await _accelTrackingTable.delete();
  }
}
