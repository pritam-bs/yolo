import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/detection_result.dart';
import 'package:yolo/domain/entities/system_health_state.dart';

part 'camera_inference_state.freezed.dart';

@freezed
abstract class CameraInferenceState with _$CameraInferenceState {
  const factory CameraInferenceState({
    @Default(CameraInferenceStatus.initial()) CameraInferenceStatus status,
    @Default(ModelType.detect) ModelType modelType,
    String? modelPath,
    @Default(0.5) double confidenceThreshold,
    @Default(0.45) double iouThreshold,
    @Default(30) int numItemsThreshold,
    @Default(InferenceParameter.none) InferenceParameter activeSlider,
    @Default(false) bool isFrontCamera,
    @Default(1.0) double currentZoomLevel,
    @Default([]) List<DetectionResult> detections,
    @Default(0.0) double currentFps,
    @Default(LensFacing.back) LensFacing currentLensFacing,
    @Default(SystemHealthState.normal) SystemHealthState systemHealthState,
  }) = _CameraInferenceState;
}

@freezed
abstract class CameraInferenceStatus with _$CameraInferenceStatus {
  const factory CameraInferenceStatus.initial() = _Initial;
  const factory CameraInferenceStatus.loading() = _Loading;
  const factory CameraInferenceStatus.modelDownloading(double progress) =
      _ModelLoading;
  const factory CameraInferenceStatus.success() = _Success;
  const factory CameraInferenceStatus.failure(String message) = _Failure;
}
