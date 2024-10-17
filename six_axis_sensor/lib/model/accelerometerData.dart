// 保存時の自動整形でfoundationが消えないように警告を消している
// ignore: unused_import, directives_ordering
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accelerometerData.freezed.dart';
part 'accelerometerData.g.dart';

@freezed
class AccelerometerData with _$AccelerometerData {
  const factory AccelerometerData({
    required DateTime time,
    required double x,
    required double y,
    required double z,
  }) = _AccelerometerData;

  factory AccelerometerData.fromJson(Map<String, dynamic> json) =>
      _$AccelerometerDataFromJson(json);
}

// class AccelerometerData {
//   final DateTime time;
//   final double x;
//   final double y;
//   final double z;

//   AccelerometerData(this.time, this.x, this.y, this.z);

//   // CSV形式でデータを出力するためのメソッド
//   @override
//   String toString() {
//     return '${time.toString()},$x,$y,$z';
//   }
// }
