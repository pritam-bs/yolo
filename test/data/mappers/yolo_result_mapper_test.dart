import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/models/yolo_result.dart';
import 'package:yolo/data/mappers/yolo_result_mapper.dart';

void main() {
  group('YOLOResultMapper', () {
    test('should correctly map YOLOResult to DetectionResult', () {
      // Arrange
      const originalImageWidth = 640.0;
      const originalImageHeight = 480.0;
      final boundingBox = Rect.fromLTWH(10, 20, 50, 60);
      final normalizedBox = Rect.fromLTWH(0.1, 0.2, 0.05, 0.06);
      const confidence = 0.95;
      const className = 'person';
      const classIndex = 0;

      final yoloResult = YOLOResult(
        originalImageWidth: originalImageWidth,
        originalImageHeight: originalImageHeight,
        boundingBox: boundingBox,
        normalizedBox: normalizedBox,
        confidence: confidence,
        className: className,
        classIndex: classIndex,
      );

      // Act
      final detectionResult = yoloResult.toDetectionResult();

      // Assert
      expect(
        detectionResult.imageSize,
        const Size(originalImageWidth, originalImageHeight),
      );
      expect(detectionResult.box, boundingBox);
      expect(detectionResult.normalizedBox, normalizedBox);
      expect(detectionResult.score, confidence);
      expect(detectionResult.label, className);
      expect(detectionResult.classId, classIndex);
    });
  });
}
