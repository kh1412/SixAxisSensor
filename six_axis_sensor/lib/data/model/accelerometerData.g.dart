// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accelerometerData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccelerometerDataImpl _$$AccelerometerDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AccelerometerDataImpl(
      time: (json['time'] as num?)?.toInt() ?? 0,
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      z: (json['z'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$AccelerometerDataImplToJson(
        _$AccelerometerDataImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };
