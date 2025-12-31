import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; // Import for Size
import 'package:yolo/application/mappers/detection_mapper.dart';
import 'package:yolo/domain/entities/detection_result.dart';

void main() {
  group('DetectionMapper', () {
    test('should correctly map DetectionResult to YOLOResult', () {
      // Arrange
      const imageWidth = 640.0;
      const imageHeight = 480.0;
      final imageSize = Size(imageWidth, imageHeight);
      final box = Rect.fromLTWH(10, 20, 50, 60);
      final normalizedBox = Rect.fromLTWH(0.1, 0.2, 0.05, 0.06);
      const score = 0.95;
      const label = 'person';
      const classId = 0;

      final detectionResult = DetectionResult(
        imageSize: imageSize,
        box: box,
        normalizedBox: normalizedBox,
        score: score,
        label: label,
        classId: classId,
      );

      // Act
      final yoloResult = DetectionMapper.toYOLOResult(detectionResult);

      // Assert
      expect(yoloResult.originalImageWidth, imageWidth);
      expect(yoloResult.originalImageHeight, imageHeight);
      expect(yoloResult.classIndex, classId);
      expect(yoloResult.className, label);
      expect(yoloResult.confidence, score);
      expect(yoloResult.boundingBox, box);
      expect(yoloResult.normalizedBox, normalizedBox);
    });
  });
}
