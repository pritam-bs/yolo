import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/detection_result.dart';

part 'camera_inference_event.freezed.dart';

@freezed
abstract class CameraInferenceEvent with _$CameraInferenceEvent {
  const factory CameraInferenceEvent.initializeCamera() = InitializeCamera;
  const factory CameraInferenceEvent.changeModel(ModelType model) = ChangeModel;
  const factory CameraInferenceEvent.flipCamera() = FlipCamera;
  const factory CameraInferenceEvent.setZoomLevel(double zoomLevel) =
      SetZoomLevel;
  const factory CameraInferenceEvent.updateConfidenceThreshold(
    double threshold,
  ) = UpdateConfidenceThreshold;
  const factory CameraInferenceEvent.updateIouThreshold(double threshold) =
      UpdateIouThreshold;
  const factory CameraInferenceEvent.updateNumItemsThreshold(int threshold) =
      UpdateNumItemsThreshold;
  const factory CameraInferenceEvent.detectionsOccurred(
    List<DetectionResult> detections,
  ) = DetectionsOccurred;
  const factory CameraInferenceEvent.toggleSlider(SliderType type) =
      ToggleSlider;
  const factory CameraInferenceEvent.updateFps(double fps) =
      UpdateFps; // New event
  const factory CameraInferenceEvent.updateLensFacing(LensFacing lensFacing) =
      UpdateLensFacing; // New event
  const factory CameraInferenceEvent.modelDownloadStarted() =
      ModelDownloadStarted;
  const factory CameraInferenceEvent.modelDownloadProgressed(double progress) =
      ModelDownloadProgressed;
  const factory CameraInferenceEvent.modelDownloadCompleted() =
      ModelDownloadCompleted;
  const factory CameraInferenceEvent.modelDownloadFailed(String errorMessage) =
      ModelDownloadFailed;
  const factory CameraInferenceEvent.retryModelDownload() = RetryModelDownload;
  const factory CameraInferenceEvent.resumeCamera() = ResumeCamera;
}
