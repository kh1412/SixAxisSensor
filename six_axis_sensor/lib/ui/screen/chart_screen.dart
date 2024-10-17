import 'package:flutter/material.dart';
import 'package:six_axis_sensor/ui/component/accelerometerChart.dart';

// Display Chart Screen : accelrometr chart
class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accelerometer Real-Time Graph')),
      body: const Center(
        child: AccelerometerChart(),
      ),
    );
  }
}
