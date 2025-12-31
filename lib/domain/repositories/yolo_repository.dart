import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/system_health_state.dart';

abstract class YoloRepository {
  Stream<ModelLoadingState> getModelPath(ModelType modelType);

  // Inference-related controls only
  Future<void> setConfidenceThreshold(double threshold);
  Future<void> setIoUThreshold(double threshold);
  Future<void> setNumItemsThreshold(int threshold);
  Future<void> setThresholds({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  });
  Future<void> setStreamingConfig(SystemHealthState healthState);
}
