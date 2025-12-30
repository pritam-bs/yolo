// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SystemMetrics {
  int get batteryLevel => throw _privateConstructorUsedError;
  double get ramUsage => throw _privateConstructorUsedError;
  ThermalState get thermalState => throw _privateConstructorUsedError;

  /// Create a copy of SystemMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemMetricsCopyWith<SystemMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemMetricsCopyWith<$Res> {
  factory $SystemMetricsCopyWith(
    SystemMetrics value,
    $Res Function(SystemMetrics) then,
  ) = _$SystemMetricsCopyWithImpl<$Res, SystemMetrics>;
  @useResult
  $Res call({int batteryLevel, double ramUsage, ThermalState thermalState});
}

/// @nodoc
class _$SystemMetricsCopyWithImpl<$Res, $Val extends SystemMetrics>
    implements $SystemMetricsCopyWith<$Res> {
  _$SystemMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batteryLevel = null,
    Object? ramUsage = null,
    Object? thermalState = null,
  }) {
    return _then(
      _value.copyWith(
            batteryLevel: null == batteryLevel
                ? _value.batteryLevel
                : batteryLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            ramUsage: null == ramUsage
                ? _value.ramUsage
                : ramUsage // ignore: cast_nullable_to_non_nullable
                      as double,
            thermalState: null == thermalState
                ? _value.thermalState
                : thermalState // ignore: cast_nullable_to_non_nullable
                      as ThermalState,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SystemMetricsImplCopyWith<$Res>
    implements $SystemMetricsCopyWith<$Res> {
  factory _$$SystemMetricsImplCopyWith(
    _$SystemMetricsImpl value,
    $Res Function(_$SystemMetricsImpl) then,
  ) = __$$SystemMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int batteryLevel, double ramUsage, ThermalState thermalState});
}

/// @nodoc
class __$$SystemMetricsImplCopyWithImpl<$Res>
    extends _$SystemMetricsCopyWithImpl<$Res, _$SystemMetricsImpl>
    implements _$$SystemMetricsImplCopyWith<$Res> {
  __$$SystemMetricsImplCopyWithImpl(
    _$SystemMetricsImpl _value,
    $Res Function(_$SystemMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batteryLevel = null,
    Object? ramUsage = null,
    Object? thermalState = null,
  }) {
    return _then(
      _$SystemMetricsImpl(
        batteryLevel: null == batteryLevel
            ? _value.batteryLevel
            : batteryLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        ramUsage: null == ramUsage
            ? _value.ramUsage
            : ramUsage // ignore: cast_nullable_to_non_nullable
                  as double,
        thermalState: null == thermalState
            ? _value.thermalState
            : thermalState // ignore: cast_nullable_to_non_nullable
                  as ThermalState,
      ),
    );
  }
}

/// @nodoc

class _$SystemMetricsImpl implements _SystemMetrics {
  const _$SystemMetricsImpl({
    required this.batteryLevel,
    required this.ramUsage,
    required this.thermalState,
  });

  @override
  final int batteryLevel;
  @override
  final double ramUsage;
  @override
  final ThermalState thermalState;

  @override
  String toString() {
    return 'SystemMetrics(batteryLevel: $batteryLevel, ramUsage: $ramUsage, thermalState: $thermalState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemMetricsImpl &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.ramUsage, ramUsage) ||
                other.ramUsage == ramUsage) &&
            (identical(other.thermalState, thermalState) ||
                other.thermalState == thermalState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, batteryLevel, ramUsage, thermalState);

  /// Create a copy of SystemMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemMetricsImplCopyWith<_$SystemMetricsImpl> get copyWith =>
      __$$SystemMetricsImplCopyWithImpl<_$SystemMetricsImpl>(this, _$identity);
}

abstract class _SystemMetrics implements SystemMetrics {
  const factory _SystemMetrics({
    required final int batteryLevel,
    required final double ramUsage,
    required final ThermalState thermalState,
  }) = _$SystemMetricsImpl;

  @override
  int get batteryLevel;
  @override
  double get ramUsage;
  @override
  ThermalState get thermalState;

  /// Create a copy of SystemMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemMetricsImplCopyWith<_$SystemMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
