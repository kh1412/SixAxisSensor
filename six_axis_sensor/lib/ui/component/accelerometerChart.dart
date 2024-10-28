import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:six_axis_sensor/data/model/accelerometerData.dart';
import 'package:six_axis_sensor/provider/accelerometerProvider.dart';

class AccelerometerChart extends HookConsumerWidget {
  const AccelerometerChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // accelerometerProvider から加速度データのストリームを取得
    final accelerometerStream = ref.watch(accelerometerProvider.stream);
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // 各軸ごとのスポットリスト
    List<FlSpot> spotsX = [];
    List<FlSpot> spotsY = [];
    List<FlSpot> spotsZ = [];

    return StreamBuilder<AccelerometerData>(
      stream: accelerometerStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final accelerometerData = snapshot.data!;
          final currentTime =
              (DateTime.now().millisecondsSinceEpoch - startTime).toDouble() /
                  1000;

          // 過去5秒間のデータのみ保持する
          final fiveSecondsAgo = currentTime - 5.0;
          spotsX.removeWhere((spot) => spot.x < fiveSecondsAgo);
          spotsY.removeWhere((spot) => spot.x < fiveSecondsAgo);
          spotsZ.removeWhere((spot) => spot.x < fiveSecondsAgo);

          // データをリストに追加
          spotsX.add(FlSpot(currentTime, accelerometerData.x));
          spotsY.add(FlSpot(currentTime, accelerometerData.y));
          spotsZ.add(FlSpot(currentTime, accelerometerData.z));

          // グラフの描画
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                minX: fiveSecondsAgo.toDouble(), // x軸を5秒前から現在までに設定
                maxX: currentTime.toDouble(),
                minY: -10,
                maxY: 10,

                lineBarsData: [
                  LineChartBarData(
                    spots: spotsX, // X軸のデータ
                    dotData: const FlDotData(show: false),
                    isCurved: false,
                    color: Colors.blueAccent, // 単一の色指定
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: spotsY, // Y軸のデータ
                    dotData: const FlDotData(show: false),
                    isCurved: false,
                    color: Colors.redAccent, // 単一の色指定
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: spotsZ, // Z軸のデータ
                    dotData: const FlDotData(show: false),
                    isCurved: false,
                    color: Colors.greenAccent, // 単一の色指定
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  //top, rightは非表示
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    axisNameSize: 5,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      // 軸ラベルのウィジェットをカスタマイズ
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10, // ここでフォントサイズを設定
                            color: Colors.black, // 必要に応じて他のスタイルも設定
                          ),
                        );
                      },
                    ),
                    drawBelowEverything: false,
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 5,
                    sideTitles: SideTitles(
                      showTitles: true,
                      // 軸ラベルのウィジェットをカスタマイズ
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toStringAsFixed(1), //下一桁まで表示
                          style: const TextStyle(
                            fontSize: 10, // ここでフォントサイズを設定
                            color: Colors.black, // 必要に応じて他のスタイルも設定
                          ),
                        );
                      },
                    ),
                    drawBelowEverything: false,
                  ),
                ),
                gridData: FlGridData(show: true),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
