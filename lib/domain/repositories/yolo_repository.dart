import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/system_health_state.dart';

abstract class YoloRepository {
  // YOLO model path
  Stream<ModelLoadingState> getModelPath(ModelType modelType);

  // Camera controls
  Future<void> setZoomLevel(double zoomLevel);
  Future<void> flipCamera();

  // Threshold and stream controls
  Future<void> setConfidenceThreshold(double threshold);
  Future<void> setIoUThreshold(double threshold);
  Future<void> setNumItemsThreshold(int threshold);
  Future<void> setThresholds({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  });
  Future<void> setStreamingConfig(SystemHealthState healthState);

  YOLOViewController get yoloViewController;
}
