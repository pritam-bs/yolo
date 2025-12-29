import 'package:ultralytics_yolo/models/yolo_result.dart';
import 'package:yolo/domain/entities/detection_result.dart';

class DetectionMapper {
  static YOLOResult toYOLOResult(DetectionResult detection) {
    return YOLOResult(
      originalImageWidth: detection.imageSize.width,
      originalImageHeight: detection.imageSize.height,
      classIndex: detection.classId,
      className: detection.label,
      confidence: detection.score,
      boundingBox: detection.box,
      normalizedBox: detection.normalizedBox,
    );
  }
}
