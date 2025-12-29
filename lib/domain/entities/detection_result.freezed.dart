// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detection_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetectionResult {

 Size get imageSize; Rect get box; Rect get normalizedBox; double get score; String get label; int get classId;
/// Create a copy of DetectionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetectionResultCopyWith<DetectionResult> get copyWith => _$DetectionResultCopyWithImpl<DetectionResult>(this as DetectionResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetectionResult&&(identical(other.imageSize, imageSize) || other.imageSize == imageSize)&&(identical(other.box, box) || other.box == box)&&(identical(other.normalizedBox, normalizedBox) || other.normalizedBox == normalizedBox)&&(identical(other.score, score) || other.score == score)&&(identical(other.label, label) || other.label == label)&&(identical(other.classId, classId) || other.classId == classId));
}


@override
int get hashCode => Object.hash(runtimeType,imageSize,box,normalizedBox,score,label,classId);

@override
String toString() {
  return 'DetectionResult(imageSize: $imageSize, box: $box, normalizedBox: $normalizedBox, score: $score, label: $label, classId: $classId)';
}


}

/// @nodoc
abstract mixin class $DetectionResultCopyWith<$Res>  {
  factory $DetectionResultCopyWith(DetectionResult value, $Res Function(DetectionResult) _then) = _$DetectionResultCopyWithImpl;
@useResult
$Res call({
 Size imageSize, Rect box, Rect normalizedBox, double score, String label, int classId
});




}
/// @nodoc
class _$DetectionResultCopyWithImpl<$Res>
    implements $DetectionResultCopyWith<$Res> {
  _$DetectionResultCopyWithImpl(this._self, this._then);

  final DetectionResult _self;
  final $Res Function(DetectionResult) _then;

/// Create a copy of DetectionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageSize = null,Object? box = null,Object? normalizedBox = null,Object? score = null,Object? label = null,Object? classId = null,}) {
  return _then(_self.copyWith(
imageSize: null == imageSize ? _self.imageSize : imageSize // ignore: cast_nullable_to_non_nullable
as Size,box: null == box ? _self.box : box // ignore: cast_nullable_to_non_nullable
as Rect,normalizedBox: null == normalizedBox ? _self.normalizedBox : normalizedBox // ignore: cast_nullable_to_non_nullable
as Rect,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DetectionResult].
extension DetectionResultPatterns on DetectionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetectionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetectionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetectionResult value)  $default,){
final _that = this;
switch (_that) {
case _DetectionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetectionResult value)?  $default,){
final _that = this;
switch (_that) {
case _DetectionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Size imageSize,  Rect box,  Rect normalizedBox,  double score,  String label,  int classId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetectionResult() when $default != null:
return $default(_that.imageSize,_that.box,_that.normalizedBox,_that.score,_that.label,_that.classId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Size imageSize,  Rect box,  Rect normalizedBox,  double score,  String label,  int classId)  $default,) {final _that = this;
switch (_that) {
case _DetectionResult():
return $default(_that.imageSize,_that.box,_that.normalizedBox,_that.score,_that.label,_that.classId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Size imageSize,  Rect box,  Rect normalizedBox,  double score,  String label,  int classId)?  $default,) {final _that = this;
switch (_that) {
case _DetectionResult() when $default != null:
return $default(_that.imageSize,_that.box,_that.normalizedBox,_that.score,_that.label,_that.classId);case _:
  return null;

}
}

}

/// @nodoc


class _DetectionResult implements DetectionResult {
  const _DetectionResult({required this.imageSize, required this.box, required this.normalizedBox, required this.score, required this.label, required this.classId});
  

@override final  Size imageSize;
@override final  Rect box;
@override final  Rect normalizedBox;
@override final  double score;
@override final  String label;
@override final  int classId;

/// Create a copy of DetectionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetectionResultCopyWith<_DetectionResult> get copyWith => __$DetectionResultCopyWithImpl<_DetectionResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetectionResult&&(identical(other.imageSize, imageSize) || other.imageSize == imageSize)&&(identical(other.box, box) || other.box == box)&&(identical(other.normalizedBox, normalizedBox) || other.normalizedBox == normalizedBox)&&(identical(other.score, score) || other.score == score)&&(identical(other.label, label) || other.label == label)&&(identical(other.classId, classId) || other.classId == classId));
}


@override
int get hashCode => Object.hash(runtimeType,imageSize,box,normalizedBox,score,label,classId);

@override
String toString() {
  return 'DetectionResult(imageSize: $imageSize, box: $box, normalizedBox: $normalizedBox, score: $score, label: $label, classId: $classId)';
}


}

/// @nodoc
abstract mixin class _$DetectionResultCopyWith<$Res> implements $DetectionResultCopyWith<$Res> {
  factory _$DetectionResultCopyWith(_DetectionResult value, $Res Function(_DetectionResult) _then) = __$DetectionResultCopyWithImpl;
@override @useResult
$Res call({
 Size imageSize, Rect box, Rect normalizedBox, double score, String label, int classId
});




}
/// @nodoc
class __$DetectionResultCopyWithImpl<$Res>
    implements _$DetectionResultCopyWith<$Res> {
  __$DetectionResultCopyWithImpl(this._self, this._then);

  final _DetectionResult _self;
  final $Res Function(_DetectionResult) _then;

/// Create a copy of DetectionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageSize = null,Object? box = null,Object? normalizedBox = null,Object? score = null,Object? label = null,Object? classId = null,}) {
  return _then(_DetectionResult(
imageSize: null == imageSize ? _self.imageSize : imageSize // ignore: cast_nullable_to_non_nullable
as Size,box: null == box ? _self.box : box // ignore: cast_nullable_to_non_nullable
as Rect,normalizedBox: null == normalizedBox ? _self.normalizedBox : normalizedBox // ignore: cast_nullable_to_non_nullable
as Rect,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
