import 'package:ultralytics_yolo/models/yolo_task.dart';
import 'package:yolo/domain/entities/models.dart';

extension ModelTypeUiMapper on ModelType {
  // Maps the domain entity to the library's specific enum
  YOLOTask get toYoloTask {
    switch (this) {
      case ModelType.detect:
        return YOLOTask.detect;
      case ModelType.segment:
        return YOLOTask.segment;
      case ModelType.classify:
        return YOLOTask.classify;
      case ModelType.pose:
        return YOLOTask.pose;
      case ModelType.obb:
        return YOLOTask.obb;
    }
  }
}
