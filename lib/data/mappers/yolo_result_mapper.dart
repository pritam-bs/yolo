import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/models/yolo_result.dart';
import 'package:yolo/domain/entities/detection_result.dart';

extension YOLOResultMapper on YOLOResult {
  DetectionResult toDetectionResult() {
    return DetectionResult(
      imageSize: Size(originalImageWidth, originalImageHeight),
      box: boundingBox,
      normalizedBox: normalizedBox,
      score: confidence,
      label: className,
      classId: classIndex,
    );
  }
}
