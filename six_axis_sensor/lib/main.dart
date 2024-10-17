import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:six_axis_sensor/ui/screen/chart_screen.dart';

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
      home: ChartScreen(),
    );
  }
}
