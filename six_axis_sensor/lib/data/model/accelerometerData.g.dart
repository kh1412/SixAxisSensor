// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accelerometerData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccelerometerDataImpl _$$AccelerometerDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AccelerometerDataImpl(
      time: DateTime.parse(json['time'] as String),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );

Map<String, dynamic> _$$AccelerometerDataImplToJson(
        _$AccelerometerDataImpl instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };
