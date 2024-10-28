import 'package:flutter/material.dart';
import 'package:six_axis_sensor/ui/component/accelerometerChart.dart';

// Display Chart Screen : accelrometr chart
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          child: AccelerometerChart(),
        ),
      ),
    );
  }
}
