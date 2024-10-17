import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:six_axis_sensor/accelerometerChart.dart';

void main() {
  runApp(
    // ProviderScopeを使ってアプリ全体にRiverpodを適用
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accelerometer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccelerometerChart(), // 加速度グラフ画面を最初に表示
    );
  }
}
