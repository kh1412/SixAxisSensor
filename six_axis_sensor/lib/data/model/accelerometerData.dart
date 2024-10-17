// 保存時の自動整形でfoundationが消えないように警告を消している
// ignore: unused_import, directives_ordering
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accelerometerData.freezed.dart';
part 'accelerometerData.g.dart';

@freezed
class AccelerometerData with _$AccelerometerData {
  const factory AccelerometerData({
    @Default(0) int time,
    @Default(0) double x,
    @Default(0) double y,
    @Default(0) double z,
  }) = _AccelerometerData;

  factory AccelerometerData.fromJson(Map<String, dynamic> json) =>
      _$AccelerometerDataFromJson(json);
}
