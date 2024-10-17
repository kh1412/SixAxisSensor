class AccelerometerData {
  final DateTime time;
  final double x;
  final double y;
  final double z;

  AccelerometerData(this.time, this.x, this.y, this.z);

  // CSV形式でデータを出力するためのメソッド
  @override
  String toString() {
    return '${time.toIso8601String()},$x,$y,$z';
  }
}
