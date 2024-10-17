import 'package:flutter/material.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accelerometer Real-Time Graph')),
      body: Center(
        child: RealTimeGraph(
          stream: accelerometerXStream(), // Stream providing accelerometer data
          graphColor: Colors.blue, // Customize the graph color
          supportNegativeValuesDisplay: true,
          xAxisColor: Colors.black12,
        ),
      ),
    );
  }

  Stream<double> accelerometerXStream() {
    return accelerometerEventStream().map((event) => event.x);
  }
}
