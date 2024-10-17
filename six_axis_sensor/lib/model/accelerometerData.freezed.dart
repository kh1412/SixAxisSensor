// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accelerometerData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccelerometerData _$AccelerometerDataFromJson(Map<String, dynamic> json) {
  return _AccelerometerData.fromJson(json);
}

/// @nodoc
mixin _$AccelerometerData {
  DateTime get time => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get z => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccelerometerDataCopyWith<AccelerometerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccelerometerDataCopyWith<$Res> {
  factory $AccelerometerDataCopyWith(
          AccelerometerData value, $Res Function(AccelerometerData) then) =
      _$AccelerometerDataCopyWithImpl<$Res, AccelerometerData>;
  @useResult
  $Res call({DateTime time, double x, double y, double z});
}

/// @nodoc
class _$AccelerometerDataCopyWithImpl<$Res, $Val extends AccelerometerData>
    implements $AccelerometerDataCopyWith<$Res> {
  _$AccelerometerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? x = null,
    Object? y = null,
    Object? z = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      z: null == z
          ? _value.z
          : z // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccelerometerDataImplCopyWith<$Res>
    implements $AccelerometerDataCopyWith<$Res> {
  factory _$$AccelerometerDataImplCopyWith(_$AccelerometerDataImpl value,
          $Res Function(_$AccelerometerDataImpl) then) =
      __$$AccelerometerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime time, double x, double y, double z});
}

/// @nodoc
class __$$AccelerometerDataImplCopyWithImpl<$Res>
    extends _$AccelerometerDataCopyWithImpl<$Res, _$AccelerometerDataImpl>
    implements _$$AccelerometerDataImplCopyWith<$Res> {
  __$$AccelerometerDataImplCopyWithImpl(_$AccelerometerDataImpl _value,
      $Res Function(_$AccelerometerDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? x = null,
    Object? y = null,
    Object? z = null,
  }) {
    return _then(_$AccelerometerDataImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      z: null == z
          ? _value.z
          : z // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccelerometerDataImpl
    with DiagnosticableTreeMixin
    implements _AccelerometerData {
  const _$AccelerometerDataImpl(
      {required this.time, required this.x, required this.y, required this.z});

  factory _$AccelerometerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccelerometerDataImplFromJson(json);

  @override
  final DateTime time;
  @override
  final double x;
  @override
  final double y;
  @override
  final double z;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccelerometerData(time: $time, x: $x, y: $y, z: $z)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccelerometerData'))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('x', x))
      ..add(DiagnosticsProperty('y', y))
      ..add(DiagnosticsProperty('z', z));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccelerometerDataImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.z, z) || other.z == z));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, time, x, y, z);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccelerometerDataImplCopyWith<_$AccelerometerDataImpl> get copyWith =>
      __$$AccelerometerDataImplCopyWithImpl<_$AccelerometerDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccelerometerDataImplToJson(
      this,
    );
  }
}

abstract class _AccelerometerData implements AccelerometerData {
  const factory _AccelerometerData(
      {required final DateTime time,
      required final double x,
      required final double y,
      required final double z}) = _$AccelerometerDataImpl;

  factory _AccelerometerData.fromJson(Map<String, dynamic> json) =
      _$AccelerometerDataImpl.fromJson;

  @override
  DateTime get time;
  @override
  double get x;
  @override
  double get y;
  @override
  double get z;
  @override
  @JsonKey(ignore: true)
  _$$AccelerometerDataImplCopyWith<_$AccelerometerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
