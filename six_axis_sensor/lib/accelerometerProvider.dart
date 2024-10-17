import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:six_axis_sensor/accelerometerData.dart'; // 仮のクラス
import 'package:six_axis_sensor/accelerometerRecorder.dart'; // 仮のクラス

// 加速度データのプロバイダー
final accelerometerProvider = StreamProvider<AccelerometerData>((ref) {
  final recorder = AccelerometerRecorder(); // Recorderクラスのインスタンスを作成
  recorder.start(); // 加速度データの取得を開始
  return recorder.accelerometerStream; // 加速度データのストリームを返す
});
