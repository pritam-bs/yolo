import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/domain/entities/models.dart'; // For ModelType
import 'package:yolo/domain/entities/model_loading_state.dart'; // For ModelLoadingState

abstract class YoloRepository {
  Stream<ModelLoadingState> getModelPath(ModelType modelType);

  // Camera controls
  void setZoomLevel(double zoomLevel);
  void flipCamera();
  void setLensFacing(LensFacing facing);

  // Threshold controls
  void setConfidenceThreshold(double threshold);
  void setIoUThreshold(double threshold);
  void setNumItemsThreshold(int threshold);

  YOLOViewController get yoloViewController;
}
