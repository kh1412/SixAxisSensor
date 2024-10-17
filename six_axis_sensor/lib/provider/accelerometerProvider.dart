import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:six_axis_sensor/data/model/accelerometerData.dart';

// 加速度データのプロバイダー
final accelerometerProvider = StreamProvider<AccelerometerData>((ref) {
  final recorder = AccelerometerRecorder(); // Recorderクラスのインスタンスを作成
  recorder.start(); // 加速度データの取得を開始
  return recorder.accelerometerStream; // 加速度データのストリームを返す
});

class AccelerometerRecorder {
  final StreamController<AccelerometerData> _streamController =
      StreamController<AccelerometerData>.broadcast();
  Timer? _timer;
  AccelerometerEvent? _lastEvent;
  final List<AccelerometerData> _dataBuffer = [];

  AccelerometerRecorder();

  // 計測を開始する
  void start() {
    _startListening();
    _startRecording();
  }

  // 計測を停止する
  void stop() async {
    _timer?.cancel();
    await _saveBufferToFile(); // バッファに残ったデータを保存
    // _streamControllerは閉じないか、後で再利用する場合は再作成
  }

  // 加速度センサのデータを監視する
  void _startListening() {
    accelerometerEventStream().listen((AccelerometerEvent event) {
      _lastEvent = event;
    });
  }

  // 100Hzでデータを取得し、Streamに流しつつファイルに保存
  void _startRecording() {
    const duration = Duration(milliseconds: 10); // 100Hz
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_lastEvent != null) {
        // 加速度データを生成してStreamに流す
        AccelerometerData data = AccelerometerData(
            time: DateTime.now().millisecondsSinceEpoch,
            x: _lastEvent!.x,
            y: _lastEvent!.y,
            z: _lastEvent!.z);
        _streamController.add(data);

        // ファイル保存用のデータとしてバッファに追加
        _dataBuffer.add(data);

        // バッファが一定数溜まったらファイルに保存する
        if (_dataBuffer.length >= 100) {
          // 1秒分のデータが溜まったら保存
          _saveBufferToFile();
        }
      }
    });
  }

  // データバッファをファイルに保存する
  Future<void> _saveBufferToFile() async {
    if (_dataBuffer.isEmpty) return;

    try {
      final file = await _getLocalFile();
      await file.writeAsString(
          _dataBuffer.map((data) => data.toString()).join('\n') + '\n',
          mode: FileMode.append);
      _dataBuffer.clear(); // バッファをクリア
    } catch (e) {
      // エラーログを表示するなど、エラーハンドリングを追加
      print("Error saving accelerometer data: $e");
    }
  }

  // ローカルファイルのパスを取得する
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/accelerometer_data.txt');
  }

  // 加速度データを取得するStream
  Stream<AccelerometerData> get accelerometerStream => _streamController.stream;
}
