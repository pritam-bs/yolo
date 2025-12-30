// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo/models/yolo_result.dart';

void main() {
  group('YOLOResult', () {
    const testBoundingBox = Rect.fromLTRB(10, 10, 110, 210);
    const testNormalizedBox = Rect.fromLTRB(0.1, 0.1, 0.5, 0.9);
    const testWidth = 1920.0;
    const testHeight = 1080.0;
    final testMeta = {'width': testWidth, 'height': testHeight};

    test('fromMap creates instance with detection data and image metadata', () {
      final detectionMap = {
        'classIndex': 1,
        'className': 'car',
        'confidence': 0.85,
        'boundingBox': {
          'left': 10.0,
          'top': 10.0,
          'right': 110.0,
          'bottom': 210.0,
        },
        'normalizedBox': {'left': 0.1, 'top': 0.1, 'right': 0.5, 'bottom': 0.9},
      };

      final result = YOLOResult.fromMap(detectionMap, testMeta);

      expect(result.originalImageWidth, testWidth);
      expect(result.originalImageHeight, testHeight);
      expect(result.classIndex, 1);
      expect(result.className, 'car');
      expect(result.confidence, 0.85);
      expect(result.boundingBox, testBoundingBox);
      expect(result.normalizedBox, testNormalizedBox);
    });

    test('fromMap handles segmentation mask data', () {
      final detectionMap = {
        'classIndex': 0,
        'className': 'person',
        'confidence': 0.95,
        'boundingBox': {
          'left': 10.0,
          'top': 10.0,
          'right': 110.0,
          'bottom': 210.0,
        },
        'normalizedBox': {'left': 0.1, 'top': 0.1, 'right': 0.5, 'bottom': 0.9},
        'mask': [
          [0.1, 0.2],
          [0.3, 0.4],
        ],
      };

      final result = YOLOResult.fromMap(detectionMap, testMeta);

      expect(result.originalImageWidth, testWidth);
      expect(result.mask, isNotNull);
      expect(result.mask!.length, 2);
    });

    test('fromMap handles pose keypoints data', () {
      final detectionMap = {
        'classIndex': 0,
        'className': 'person',
        'confidence': 0.9,
        'boundingBox': {
          'left': 10.0,
          'top': 10.0,
          'right': 110.0,
          'bottom': 210.0,
        },
        'normalizedBox': {'left': 0.1, 'top': 0.1, 'right': 0.5, 'bottom': 0.9},
        'keypoints': [0.5, 0.3, 0.8, 0.6, 0.4, 0.9],
      };

      final result = YOLOResult.fromMap(detectionMap, testMeta);

      expect(result.keypoints, isNotNull);
      expect(result.keypoints!.length, 2);
      expect(result.keypoints![0].x, 0.5);
      expect(result.keypointConfidences![0], 0.8);
    });

    test('fromMap handles minimal data', () {
      final detectionMap = {
        'classIndex': 0,
        'className': 'object',
        'confidence': 0.5,
      };

      final result = YOLOResult.fromMap(detectionMap, testMeta);

      expect(result.originalImageWidth, testWidth);
      expect(result.boundingBox, Rect.zero);
      expect(result.mask, isNull);
    });

    test('constructor creates instance with all parameters', () {
      final keypoints = [Point(0.5, 0.3), Point(0.6, 0.4)];
      final keypointConfidences = [0.8, 0.9];
      final mask = [
        [0.1, 0.2],
        [0.3, 0.4],
      ];

      final result = YOLOResult(
        originalImageWidth: testWidth,
        originalImageHeight: testHeight,
        classIndex: 0,
        className: 'person',
        confidence: 0.9,
        boundingBox: testBoundingBox,
        normalizedBox: testNormalizedBox,
        keypoints: keypoints,
        keypointConfidences: keypointConfidences,
        mask: mask,
      );

      expect(result.originalImageWidth, testWidth);
      expect(result.originalImageHeight, testHeight);
      expect(result.keypoints, keypoints);
      expect(result.mask, mask);
    });

    test('toMap converts instance to map including original dimensions', () {
      final result = YOLOResult(
        originalImageWidth: testWidth,
        originalImageHeight: testHeight,
        classIndex: 1,
        className: 'car',
        confidence: 0.85,
        boundingBox: testBoundingBox,
        normalizedBox: testNormalizedBox,
      );

      final map = result.toMap();

      expect(map['originalImageWidth'], testWidth);
      expect(map['originalImageHeight'], testHeight);
      expect(map['classIndex'], 1);
      expect(map['className'], 'car');
    });

    test('toMap with keypoints serialization check', () {
      final result = YOLOResult(
        originalImageWidth: testWidth,
        originalImageHeight: testHeight,
        classIndex: 0,
        className: 'person',
        confidence: 0.95,
        boundingBox: testBoundingBox,
        normalizedBox: testNormalizedBox,
        keypoints: [Point(50, 60), Point(70, 80)],
        keypointConfidences: [0.9, 0.8],
      );

      final map = result.toMap();

      expect(map['keypoints'], isA<List<double>>());
      expect(map['keypoints'].length, 6); // 2 points * (x,y,conf)
    });
  });

  group('YOLODetectionResults', () {
    test('constructor and properties with image dimensions', () {
      final detections = [
        YOLOResult(
          originalImageWidth: 1000.0,
          originalImageHeight: 500.0,
          classIndex: 0,
          className: 'person',
          confidence: 0.9,
          boundingBox: const Rect.fromLTWH(0, 0, 100, 200),
          normalizedBox: const Rect.fromLTWH(0, 0, 0.5, 1.0),
        ),
      ];
      final imageBytes = Uint8List.fromList([1, 2, 3, 4]);

      final results = YOLODetectionResults(
        detections: detections,
        annotatedImage: imageBytes,
        processingTimeMs: 50.0,
      );

      expect(results.detections, detections);
      expect(results.detections.first.originalImageWidth, 1000.0);
      expect(results.processingTimeMs, 50.0);
    });

    test('fromMap correctly propagates originalImageSize to detections', () {
      final map = {
        'originalImageSize': {'width': 1280.0, 'height': 720.0},
        'detections': [
          {
            'classIndex': 0,
            'className': 'person',
            'confidence': 0.9,
            'boundingBox': {
              'left': 0.0,
              'top': 0.0,
              'right': 100.0,
              'bottom': 200.0,
            },
            'normalizedBox': {
              'left': 0.0,
              'top': 0.0,
              'right': 0.5,
              'bottom': 1.0,
            },
          },
        ],
        'processingTimeMs': 50.0,
      };

      final results = YOLODetectionResults.fromMap(map);

      expect(results.detections.length, 1);
      expect(results.detections.first.originalImageWidth, 1280.0);
      expect(results.detections.first.originalImageHeight, 720.0);
    });

    test('toMap includes originalImageSize metadata', () {
      final detections = [
        YOLOResult(
          originalImageWidth: 800.0,
          originalImageHeight: 600.0,
          classIndex: 0,
          className: 'person',
          confidence: 0.9,
          boundingBox: const Rect.fromLTWH(0, 0, 100, 200),
          normalizedBox: const Rect.fromLTWH(0, 0, 0.5, 1.0),
        ),
      ];

      final results = YOLODetectionResults(
        detections: detections,
        processingTimeMs: 30.0,
      );

      final map = results.toMap();

      expect(map['originalImageSize'], isNotNull);
      expect(map['originalImageSize']['width'], 800.0);
      expect(map['originalImageSize']['height'], 600.0);
    });
  });

  group('Point', () {
    test('toMap and fromMap consistency', () {
      final original = Point(150.5, 200.0);
      final map = original.toMap();
      final fromMapPoint = Point.fromMap(map);

      expect(fromMapPoint.x, original.x);
      expect(fromMapPoint.y, original.y);
    });
  });
}
