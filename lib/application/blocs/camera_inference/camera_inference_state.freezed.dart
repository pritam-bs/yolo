// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_inference_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CameraInferenceState {

 CameraInferenceStatus get status; ModelType get modelType; String? get modelPath; double get confidenceThreshold; double get iouThreshold; int get numItemsThreshold; SliderType get activeSlider; bool get isFrontCamera; double get currentZoomLevel; List<DetectionResult> get detections; double get currentFps; LensFacing get currentLensFacing; String? get errorMessage;
/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraInferenceStateCopyWith<CameraInferenceState> get copyWith => _$CameraInferenceStateCopyWithImpl<CameraInferenceState>(this as CameraInferenceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraInferenceState&&(identical(other.status, status) || other.status == status)&&(identical(other.modelType, modelType) || other.modelType == modelType)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.confidenceThreshold, confidenceThreshold) || other.confidenceThreshold == confidenceThreshold)&&(identical(other.iouThreshold, iouThreshold) || other.iouThreshold == iouThreshold)&&(identical(other.numItemsThreshold, numItemsThreshold) || other.numItemsThreshold == numItemsThreshold)&&(identical(other.activeSlider, activeSlider) || other.activeSlider == activeSlider)&&(identical(other.isFrontCamera, isFrontCamera) || other.isFrontCamera == isFrontCamera)&&(identical(other.currentZoomLevel, currentZoomLevel) || other.currentZoomLevel == currentZoomLevel)&&const DeepCollectionEquality().equals(other.detections, detections)&&(identical(other.currentFps, currentFps) || other.currentFps == currentFps)&&(identical(other.currentLensFacing, currentLensFacing) || other.currentLensFacing == currentLensFacing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,modelType,modelPath,confidenceThreshold,iouThreshold,numItemsThreshold,activeSlider,isFrontCamera,currentZoomLevel,const DeepCollectionEquality().hash(detections),currentFps,currentLensFacing,errorMessage);

@override
String toString() {
  return 'CameraInferenceState(status: $status, modelType: $modelType, modelPath: $modelPath, confidenceThreshold: $confidenceThreshold, iouThreshold: $iouThreshold, numItemsThreshold: $numItemsThreshold, activeSlider: $activeSlider, isFrontCamera: $isFrontCamera, currentZoomLevel: $currentZoomLevel, detections: $detections, currentFps: $currentFps, currentLensFacing: $currentLensFacing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CameraInferenceStateCopyWith<$Res>  {
  factory $CameraInferenceStateCopyWith(CameraInferenceState value, $Res Function(CameraInferenceState) _then) = _$CameraInferenceStateCopyWithImpl;
@useResult
$Res call({
 CameraInferenceStatus status, ModelType modelType, String? modelPath, double confidenceThreshold, double iouThreshold, int numItemsThreshold, SliderType activeSlider, bool isFrontCamera, double currentZoomLevel, List<DetectionResult> detections, double currentFps, LensFacing currentLensFacing, String? errorMessage
});


$CameraInferenceStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$CameraInferenceStateCopyWithImpl<$Res>
    implements $CameraInferenceStateCopyWith<$Res> {
  _$CameraInferenceStateCopyWithImpl(this._self, this._then);

  final CameraInferenceState _self;
  final $Res Function(CameraInferenceState) _then;

/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? modelType = null,Object? modelPath = freezed,Object? confidenceThreshold = null,Object? iouThreshold = null,Object? numItemsThreshold = null,Object? activeSlider = null,Object? isFrontCamera = null,Object? currentZoomLevel = null,Object? detections = null,Object? currentFps = null,Object? currentLensFacing = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CameraInferenceStatus,modelType: null == modelType ? _self.modelType : modelType // ignore: cast_nullable_to_non_nullable
as ModelType,modelPath: freezed == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String?,confidenceThreshold: null == confidenceThreshold ? _self.confidenceThreshold : confidenceThreshold // ignore: cast_nullable_to_non_nullable
as double,iouThreshold: null == iouThreshold ? _self.iouThreshold : iouThreshold // ignore: cast_nullable_to_non_nullable
as double,numItemsThreshold: null == numItemsThreshold ? _self.numItemsThreshold : numItemsThreshold // ignore: cast_nullable_to_non_nullable
as int,activeSlider: null == activeSlider ? _self.activeSlider : activeSlider // ignore: cast_nullable_to_non_nullable
as SliderType,isFrontCamera: null == isFrontCamera ? _self.isFrontCamera : isFrontCamera // ignore: cast_nullable_to_non_nullable
as bool,currentZoomLevel: null == currentZoomLevel ? _self.currentZoomLevel : currentZoomLevel // ignore: cast_nullable_to_non_nullable
as double,detections: null == detections ? _self.detections : detections // ignore: cast_nullable_to_non_nullable
as List<DetectionResult>,currentFps: null == currentFps ? _self.currentFps : currentFps // ignore: cast_nullable_to_non_nullable
as double,currentLensFacing: null == currentLensFacing ? _self.currentLensFacing : currentLensFacing // ignore: cast_nullable_to_non_nullable
as LensFacing,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CameraInferenceStatusCopyWith<$Res> get status {
  
  return $CameraInferenceStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [CameraInferenceState].
extension CameraInferenceStatePatterns on CameraInferenceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CameraInferenceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraInferenceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CameraInferenceState value)  $default,){
final _that = this;
switch (_that) {
case _CameraInferenceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CameraInferenceState value)?  $default,){
final _that = this;
switch (_that) {
case _CameraInferenceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CameraInferenceStatus status,  ModelType modelType,  String? modelPath,  double confidenceThreshold,  double iouThreshold,  int numItemsThreshold,  SliderType activeSlider,  bool isFrontCamera,  double currentZoomLevel,  List<DetectionResult> detections,  double currentFps,  LensFacing currentLensFacing,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraInferenceState() when $default != null:
return $default(_that.status,_that.modelType,_that.modelPath,_that.confidenceThreshold,_that.iouThreshold,_that.numItemsThreshold,_that.activeSlider,_that.isFrontCamera,_that.currentZoomLevel,_that.detections,_that.currentFps,_that.currentLensFacing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CameraInferenceStatus status,  ModelType modelType,  String? modelPath,  double confidenceThreshold,  double iouThreshold,  int numItemsThreshold,  SliderType activeSlider,  bool isFrontCamera,  double currentZoomLevel,  List<DetectionResult> detections,  double currentFps,  LensFacing currentLensFacing,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CameraInferenceState():
return $default(_that.status,_that.modelType,_that.modelPath,_that.confidenceThreshold,_that.iouThreshold,_that.numItemsThreshold,_that.activeSlider,_that.isFrontCamera,_that.currentZoomLevel,_that.detections,_that.currentFps,_that.currentLensFacing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CameraInferenceStatus status,  ModelType modelType,  String? modelPath,  double confidenceThreshold,  double iouThreshold,  int numItemsThreshold,  SliderType activeSlider,  bool isFrontCamera,  double currentZoomLevel,  List<DetectionResult> detections,  double currentFps,  LensFacing currentLensFacing,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CameraInferenceState() when $default != null:
return $default(_that.status,_that.modelType,_that.modelPath,_that.confidenceThreshold,_that.iouThreshold,_that.numItemsThreshold,_that.activeSlider,_that.isFrontCamera,_that.currentZoomLevel,_that.detections,_that.currentFps,_that.currentLensFacing,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CameraInferenceState implements CameraInferenceState {
  const _CameraInferenceState({this.status = const CameraInferenceStatus.initial(), this.modelType = ModelType.detect, this.modelPath, this.confidenceThreshold = 0.5, this.iouThreshold = 0.45, this.numItemsThreshold = 30, this.activeSlider = SliderType.none, this.isFrontCamera = false, this.currentZoomLevel = 1.0, final  List<DetectionResult> detections = const [], this.currentFps = 0.0, this.currentLensFacing = LensFacing.back, this.errorMessage}): _detections = detections;
  

@override@JsonKey() final  CameraInferenceStatus status;
@override@JsonKey() final  ModelType modelType;
@override final  String? modelPath;
@override@JsonKey() final  double confidenceThreshold;
@override@JsonKey() final  double iouThreshold;
@override@JsonKey() final  int numItemsThreshold;
@override@JsonKey() final  SliderType activeSlider;
@override@JsonKey() final  bool isFrontCamera;
@override@JsonKey() final  double currentZoomLevel;
 final  List<DetectionResult> _detections;
@override@JsonKey() List<DetectionResult> get detections {
  if (_detections is EqualUnmodifiableListView) return _detections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detections);
}

@override@JsonKey() final  double currentFps;
@override@JsonKey() final  LensFacing currentLensFacing;
@override final  String? errorMessage;

/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraInferenceStateCopyWith<_CameraInferenceState> get copyWith => __$CameraInferenceStateCopyWithImpl<_CameraInferenceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraInferenceState&&(identical(other.status, status) || other.status == status)&&(identical(other.modelType, modelType) || other.modelType == modelType)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.confidenceThreshold, confidenceThreshold) || other.confidenceThreshold == confidenceThreshold)&&(identical(other.iouThreshold, iouThreshold) || other.iouThreshold == iouThreshold)&&(identical(other.numItemsThreshold, numItemsThreshold) || other.numItemsThreshold == numItemsThreshold)&&(identical(other.activeSlider, activeSlider) || other.activeSlider == activeSlider)&&(identical(other.isFrontCamera, isFrontCamera) || other.isFrontCamera == isFrontCamera)&&(identical(other.currentZoomLevel, currentZoomLevel) || other.currentZoomLevel == currentZoomLevel)&&const DeepCollectionEquality().equals(other._detections, _detections)&&(identical(other.currentFps, currentFps) || other.currentFps == currentFps)&&(identical(other.currentLensFacing, currentLensFacing) || other.currentLensFacing == currentLensFacing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,modelType,modelPath,confidenceThreshold,iouThreshold,numItemsThreshold,activeSlider,isFrontCamera,currentZoomLevel,const DeepCollectionEquality().hash(_detections),currentFps,currentLensFacing,errorMessage);

@override
String toString() {
  return 'CameraInferenceState(status: $status, modelType: $modelType, modelPath: $modelPath, confidenceThreshold: $confidenceThreshold, iouThreshold: $iouThreshold, numItemsThreshold: $numItemsThreshold, activeSlider: $activeSlider, isFrontCamera: $isFrontCamera, currentZoomLevel: $currentZoomLevel, detections: $detections, currentFps: $currentFps, currentLensFacing: $currentLensFacing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CameraInferenceStateCopyWith<$Res> implements $CameraInferenceStateCopyWith<$Res> {
  factory _$CameraInferenceStateCopyWith(_CameraInferenceState value, $Res Function(_CameraInferenceState) _then) = __$CameraInferenceStateCopyWithImpl;
@override @useResult
$Res call({
 CameraInferenceStatus status, ModelType modelType, String? modelPath, double confidenceThreshold, double iouThreshold, int numItemsThreshold, SliderType activeSlider, bool isFrontCamera, double currentZoomLevel, List<DetectionResult> detections, double currentFps, LensFacing currentLensFacing, String? errorMessage
});


@override $CameraInferenceStatusCopyWith<$Res> get status;

}
/// @nodoc
class __$CameraInferenceStateCopyWithImpl<$Res>
    implements _$CameraInferenceStateCopyWith<$Res> {
  __$CameraInferenceStateCopyWithImpl(this._self, this._then);

  final _CameraInferenceState _self;
  final $Res Function(_CameraInferenceState) _then;

/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? modelType = null,Object? modelPath = freezed,Object? confidenceThreshold = null,Object? iouThreshold = null,Object? numItemsThreshold = null,Object? activeSlider = null,Object? isFrontCamera = null,Object? currentZoomLevel = null,Object? detections = null,Object? currentFps = null,Object? currentLensFacing = null,Object? errorMessage = freezed,}) {
  return _then(_CameraInferenceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CameraInferenceStatus,modelType: null == modelType ? _self.modelType : modelType // ignore: cast_nullable_to_non_nullable
as ModelType,modelPath: freezed == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String?,confidenceThreshold: null == confidenceThreshold ? _self.confidenceThreshold : confidenceThreshold // ignore: cast_nullable_to_non_nullable
as double,iouThreshold: null == iouThreshold ? _self.iouThreshold : iouThreshold // ignore: cast_nullable_to_non_nullable
as double,numItemsThreshold: null == numItemsThreshold ? _self.numItemsThreshold : numItemsThreshold // ignore: cast_nullable_to_non_nullable
as int,activeSlider: null == activeSlider ? _self.activeSlider : activeSlider // ignore: cast_nullable_to_non_nullable
as SliderType,isFrontCamera: null == isFrontCamera ? _self.isFrontCamera : isFrontCamera // ignore: cast_nullable_to_non_nullable
as bool,currentZoomLevel: null == currentZoomLevel ? _self.currentZoomLevel : currentZoomLevel // ignore: cast_nullable_to_non_nullable
as double,detections: null == detections ? _self._detections : detections // ignore: cast_nullable_to_non_nullable
as List<DetectionResult>,currentFps: null == currentFps ? _self.currentFps : currentFps // ignore: cast_nullable_to_non_nullable
as double,currentLensFacing: null == currentLensFacing ? _self.currentLensFacing : currentLensFacing // ignore: cast_nullable_to_non_nullable
as LensFacing,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CameraInferenceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CameraInferenceStatusCopyWith<$Res> get status {
  
  return $CameraInferenceStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

/// @nodoc
mixin _$CameraInferenceStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraInferenceStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CameraInferenceStatus()';
}


}

/// @nodoc
class $CameraInferenceStatusCopyWith<$Res>  {
$CameraInferenceStatusCopyWith(CameraInferenceStatus _, $Res Function(CameraInferenceStatus) __);
}


/// Adds pattern-matching-related methods to [CameraInferenceStatus].
extension CameraInferenceStatusPatterns on CameraInferenceStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _ModelLoading value)?  modelLoading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ModelLoading() when modelLoading != null:
return modelLoading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _ModelLoading value)  modelLoading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _ModelLoading():
return modelLoading(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _ModelLoading value)?  modelLoading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ModelLoading() when modelLoading != null:
return modelLoading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( double progress)?  modelLoading,TResult Function()?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ModelLoading() when modelLoading != null:
return modelLoading(_that.progress);case _Success() when success != null:
return success();case _Failure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( double progress)  modelLoading,required TResult Function()  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _ModelLoading():
return modelLoading(_that.progress);case _Success():
return success();case _Failure():
return failure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( double progress)?  modelLoading,TResult? Function()?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ModelLoading() when modelLoading != null:
return modelLoading(_that.progress);case _Success() when success != null:
return success();case _Failure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CameraInferenceStatus {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CameraInferenceStatus.initial()';
}


}




/// @nodoc


class _Loading implements CameraInferenceStatus {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CameraInferenceStatus.loading()';
}


}




/// @nodoc


class _ModelLoading implements CameraInferenceStatus {
  const _ModelLoading(this.progress);
  

 final  double progress;

/// Create a copy of CameraInferenceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelLoadingCopyWith<_ModelLoading> get copyWith => __$ModelLoadingCopyWithImpl<_ModelLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelLoading&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'CameraInferenceStatus.modelLoading(progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$ModelLoadingCopyWith<$Res> implements $CameraInferenceStatusCopyWith<$Res> {
  factory _$ModelLoadingCopyWith(_ModelLoading value, $Res Function(_ModelLoading) _then) = __$ModelLoadingCopyWithImpl;
@useResult
$Res call({
 double progress
});




}
/// @nodoc
class __$ModelLoadingCopyWithImpl<$Res>
    implements _$ModelLoadingCopyWith<$Res> {
  __$ModelLoadingCopyWithImpl(this._self, this._then);

  final _ModelLoading _self;
  final $Res Function(_ModelLoading) _then;

/// Create a copy of CameraInferenceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(_ModelLoading(
null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Success implements CameraInferenceStatus {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CameraInferenceStatus.success()';
}


}




/// @nodoc


class _Failure implements CameraInferenceStatus {
  const _Failure(this.message);
  

 final  String message;

/// Create a copy of CameraInferenceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CameraInferenceStatus.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $CameraInferenceStatusCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of CameraInferenceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
