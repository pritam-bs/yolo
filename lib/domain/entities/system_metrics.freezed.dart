// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SystemMetrics {

 int get batteryLevel; double get ramUsage; ThermalState get thermalState;
/// Create a copy of SystemMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemMetricsCopyWith<SystemMetrics> get copyWith => _$SystemMetricsCopyWithImpl<SystemMetrics>(this as SystemMetrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemMetrics&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.ramUsage, ramUsage) || other.ramUsage == ramUsage)&&(identical(other.thermalState, thermalState) || other.thermalState == thermalState));
}


@override
int get hashCode => Object.hash(runtimeType,batteryLevel,ramUsage,thermalState);

@override
String toString() {
  return 'SystemMetrics(batteryLevel: $batteryLevel, ramUsage: $ramUsage, thermalState: $thermalState)';
}


}

/// @nodoc
abstract mixin class $SystemMetricsCopyWith<$Res>  {
  factory $SystemMetricsCopyWith(SystemMetrics value, $Res Function(SystemMetrics) _then) = _$SystemMetricsCopyWithImpl;
@useResult
$Res call({
 int batteryLevel, double ramUsage, ThermalState thermalState
});




}
/// @nodoc
class _$SystemMetricsCopyWithImpl<$Res>
    implements $SystemMetricsCopyWith<$Res> {
  _$SystemMetricsCopyWithImpl(this._self, this._then);

  final SystemMetrics _self;
  final $Res Function(SystemMetrics) _then;

/// Create a copy of SystemMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? batteryLevel = null,Object? ramUsage = null,Object? thermalState = null,}) {
  return _then(_self.copyWith(
batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,ramUsage: null == ramUsage ? _self.ramUsage : ramUsage // ignore: cast_nullable_to_non_nullable
as double,thermalState: null == thermalState ? _self.thermalState : thermalState // ignore: cast_nullable_to_non_nullable
as ThermalState,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemMetrics].
extension SystemMetricsPatterns on SystemMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemMetrics value)  $default,){
final _that = this;
switch (_that) {
case _SystemMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _SystemMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int batteryLevel,  double ramUsage,  ThermalState thermalState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemMetrics() when $default != null:
return $default(_that.batteryLevel,_that.ramUsage,_that.thermalState);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int batteryLevel,  double ramUsage,  ThermalState thermalState)  $default,) {final _that = this;
switch (_that) {
case _SystemMetrics():
return $default(_that.batteryLevel,_that.ramUsage,_that.thermalState);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int batteryLevel,  double ramUsage,  ThermalState thermalState)?  $default,) {final _that = this;
switch (_that) {
case _SystemMetrics() when $default != null:
return $default(_that.batteryLevel,_that.ramUsage,_that.thermalState);case _:
  return null;

}
}

}

/// @nodoc


class _SystemMetrics implements SystemMetrics {
  const _SystemMetrics({required this.batteryLevel, required this.ramUsage, required this.thermalState});
  

@override final  int batteryLevel;
@override final  double ramUsage;
@override final  ThermalState thermalState;

/// Create a copy of SystemMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemMetricsCopyWith<_SystemMetrics> get copyWith => __$SystemMetricsCopyWithImpl<_SystemMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemMetrics&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.ramUsage, ramUsage) || other.ramUsage == ramUsage)&&(identical(other.thermalState, thermalState) || other.thermalState == thermalState));
}


@override
int get hashCode => Object.hash(runtimeType,batteryLevel,ramUsage,thermalState);

@override
String toString() {
  return 'SystemMetrics(batteryLevel: $batteryLevel, ramUsage: $ramUsage, thermalState: $thermalState)';
}


}

/// @nodoc
abstract mixin class _$SystemMetricsCopyWith<$Res> implements $SystemMetricsCopyWith<$Res> {
  factory _$SystemMetricsCopyWith(_SystemMetrics value, $Res Function(_SystemMetrics) _then) = __$SystemMetricsCopyWithImpl;
@override @useResult
$Res call({
 int batteryLevel, double ramUsage, ThermalState thermalState
});




}
/// @nodoc
class __$SystemMetricsCopyWithImpl<$Res>
    implements _$SystemMetricsCopyWith<$Res> {
  __$SystemMetricsCopyWithImpl(this._self, this._then);

  final _SystemMetrics _self;
  final $Res Function(_SystemMetrics) _then;

/// Create a copy of SystemMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? batteryLevel = null,Object? ramUsage = null,Object? thermalState = null,}) {
  return _then(_SystemMetrics(
batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,ramUsage: null == ramUsage ? _self.ramUsage : ramUsage // ignore: cast_nullable_to_non_nullable
as double,thermalState: null == thermalState ? _self.thermalState : thermalState // ignore: cast_nullable_to_non_nullable
as ThermalState,
  ));
}


}

// dart format on
