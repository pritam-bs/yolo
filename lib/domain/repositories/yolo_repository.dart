import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';

abstract class YoloRepository {
  // YOLO model path
  Stream<ModelLoadingState> getModelPath(ModelType modelType);

  // Camera controls
  void setZoomLevel(double zoomLevel);
  void flipCamera();

  // Threshold controls
  void setConfidenceThreshold(double threshold);
  void setIoUThreshold(double threshold);
  void setNumItemsThreshold(int threshold);
  void setThresholds({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  });

  YOLOViewController get yoloViewController;
}
