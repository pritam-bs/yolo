import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo/models/yolo_task.dart';
import 'package:yolo/application/mappers/model_type_ui_mapper.dart';
import 'package:yolo/domain/entities/models.dart';

void main() {
  group('ModelTypeUiMapper', () {
    test('should map ModelType.detect to YOLOTask.detect', () {
      // Arrange
      const modelType = ModelType.detect;

      // Act
      final yoloTask = modelType.toYoloTask;

      // Assert
      expect(yoloTask, YOLOTask.detect);
    });

    test('should map ModelType.segment to YOLOTask.segment', () {
      // Arrange
      const modelType = ModelType.segment;

      // Act
      final yoloTask = modelType.toYoloTask;

      // Assert
      expect(yoloTask, YOLOTask.segment);
    });

    test('should map ModelType.classify to YOLOTask.classify', () {
      // Arrange
      const modelType = ModelType.classify;

      // Act
      final yoloTask = modelType.toYoloTask;

      // Assert
      expect(yoloTask, YOLOTask.classify);
    });

    test('should map ModelType.pose to YOLOTask.pose', () {
      // Arrange
      const modelType = ModelType.pose;

      // Act
      final yoloTask = modelType.toYoloTask;

      // Assert
      expect(yoloTask, YOLOTask.pose);
    });

    test('should map ModelType.obb to YOLOTask.obb', () {
      // Arrange
      const modelType = ModelType.obb;

      // Act
      final yoloTask = modelType.toYoloTask;

      // Assert
      expect(yoloTask, YOLOTask.obb);
    });
  });
}
