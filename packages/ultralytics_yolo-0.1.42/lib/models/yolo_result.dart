// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

// lib/yolo_result.dart

import 'dart:typed_data';
import 'dart:ui';
import '../utils/map_converter.dart';

/// Represents a detection result from YOLO models.
///
/// This class encapsulates all the information returned by YOLO models
/// for a single detected object, including its location, classification,
/// and dimensions of the source image for accurate coordinate mapping.
///
/// Example:
/// ```dart
/// final result = YOLOResult(
///   originalImageWidth: 1920,
///   originalImageHeight: 1080,
///   classIndex: 0,
///   className: 'person',
///   confidence: 0.95,
///   boundingBox: Rect.fromLTWH(100, 100, 200, 300),
///   normalizedBox: Rect.fromLTWH(0.1, 0.1, 0.2, 0.3),
/// );
/// ```
class YOLOResult {
  /// The width of the original image/frame processed by the model.
  final double originalImageWidth;

  /// The height of the original image/frame processed by the model.
  final double originalImageHeight;

  /// The index of the detected class in the model's class list.
  ///
  /// This corresponds to the position of the class in the model's
  /// training dataset labels.
  final int classIndex;

  /// The human-readable name of the detected class.
  ///
  /// Examples: "person", "car", "dog", "chair", etc.
  /// The exact names depend on the model's training dataset.
  final String className;

  /// The confidence score of the detection.
  ///
  /// A value between 0.0 and 1.0 representing the model's
  /// confidence in this detection. Higher values indicate
  /// more confident detections.
  final double confidence;

  /// The bounding box of the detected object in pixel coordinates.
  ///
  /// This rectangle defines the location and size of the detected
  /// object within the original image, using absolute pixel values.
  final Rect boundingBox;

  /// The normalized bounding box coordinates.
  ///
  /// All values are between 0.0 and 1.0, representing the relative
  /// position and size within the image. This is useful for
  /// resolution-independent processing.
  final Rect normalizedBox;

  /// The segmentation mask for instance segmentation tasks.
  ///
  /// Only available when using segmentation models (YOLOTask.segment).
  /// Each inner list represents a row of mask values.
  final List<List<double>>? mask;

  /// The detected keypoints for pose estimation tasks.
  ///
  /// Only available when using pose models (YOLOTask.pose).
  /// Common keypoints include body joints like shoulders, elbows, knees, etc.
  final List<Point>? keypoints;

  /// The confidence values for each detected keypoint.
  ///
  /// Only available when using pose models (YOLOTask.pose).
  /// Each value corresponds to a keypoint in the [keypoints] list
  /// and ranges from 0.0 to 1.0.
  final List<double>? keypointConfidences;

  YOLOResult({
    required this.originalImageWidth,
    required this.originalImageHeight,
    required this.classIndex,
    required this.className,
    required this.confidence,
    required this.boundingBox,
    required this.normalizedBox,
    this.mask,
    this.keypoints,
    this.keypointConfidences,
  });

  /// Creates a [YOLOResult] from a map representation.
  ///
  /// This factory constructor is primarily used for deserializing results
  /// received from the platform channel. The detectionMap should contain keys:
  /// - 'classIndex': int
  /// - 'className': String
  /// - 'confidence': double
  /// - 'boundingBox': Map with 'left', 'top', 'right', 'bottom'
  /// - 'normalizedBox': Map with 'left', 'top', 'right', 'bottom'
  /// - 'mask': (optional) List of List of double
  /// - 'keypoints': (optional) List of double in x,y,confidence triplets
  /// and the imageMetaMap should contain keys:
  /// - width: The width of the original image that fit to YOLO model
  /// - height: The height of the original image that fit to YOLO model
  factory YOLOResult.fromMap(
    Map<dynamic, dynamic> detectionMap,
    Map<dynamic, dynamic> imageMetaMap,
  ) {
    // Extract dimensions from the passed metadata map
    final double width = (imageMetaMap['width'] ?? 0.0).toDouble();
    final double height = (imageMetaMap['height'] ?? 0.0).toDouble();

    final classIndex = MapConverter.safeGetInt(detectionMap, 'classIndex');
    final className = MapConverter.safeGetString(detectionMap, 'className');
    final confidence = MapConverter.safeGetDouble(detectionMap, 'confidence');

    final boxMap = MapConverter.convertToTypedMapSafe(
      detectionMap['boundingBox'] as Map<dynamic, dynamic>?,
    );
    final boundingBox = boxMap != null
        ? MapConverter.convertBoundingBox(boxMap)
        : Rect.zero;

    final normalizedBoxMap = MapConverter.convertToTypedMapSafe(
      detectionMap['normalizedBox'] as Map<dynamic, dynamic>?,
    );
    final normalizedBox = normalizedBoxMap != null
        ? MapConverter.convertBoundingBox(normalizedBoxMap)
        : Rect.zero;

    List<List<double>>? mask;
    if (detectionMap.containsKey('mask') && detectionMap['mask'] != null) {
      final maskData = detectionMap['mask'] as List<dynamic>;
      mask = MapConverter.convertMaskData(maskData);
    }

    List<Point>? keypoints;
    List<double>? keypointConfidences;
    if (detectionMap.containsKey('keypoints') &&
        detectionMap['keypoints'] != null) {
      final keypointsData = detectionMap['keypoints'] as List<dynamic>;
      final keypointResult = MapConverter.convertKeypoints(keypointsData);
      keypoints = keypointResult.keypoints;
      keypointConfidences = keypointResult.confidences;
    }

    return YOLOResult(
      originalImageWidth: width,
      originalImageHeight: height,
      classIndex: classIndex,
      className: className,
      confidence: confidence,
      boundingBox: boundingBox,
      normalizedBox: normalizedBox,
      mask: mask,
      keypoints: keypoints,
      keypointConfidences: keypointConfidences,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'originalImageWidth': originalImageWidth,
      'originalImageHeight': originalImageHeight,
      'classIndex': classIndex,
      'className': className,
      'confidence': confidence,
      'boundingBox': {
        'left': boundingBox.left,
        'top': boundingBox.top,
        'right': boundingBox.right,
        'bottom': boundingBox.bottom,
      },
      'normalizedBox': {
        'left': normalizedBox.left,
        'top': normalizedBox.top,
        'right': normalizedBox.right,
        'bottom': normalizedBox.bottom,
      },
    };

    if (mask != null) {
      map['mask'] = mask;
    }

    if (keypoints != null && keypointConfidences != null) {
      final keypointsData = <double>[];
      for (var i = 0; i < keypoints!.length; i++) {
        keypointsData.add(keypoints![i].x);
        keypointsData.add(keypoints![i].y);
        keypointsData.add(keypointConfidences![i]);
      }
      map['keypoints'] = keypointsData;
    }

    return map;
  }

  @override
  String toString() {
    return 'YOLOResult{className: $className, confidence: $confidence, img: ${originalImageWidth.toInt()}x${originalImageHeight.toInt()}}';
  }
}

/// Represents a collection of detection results from YOLO models.
///
/// This class encapsulates the complete output from a YOLO inference,
/// including all detected objects, an optional annotated image showing
/// the detections, and performance metrics.
///
/// Example:
/// ```dart
/// final results = await yolo.predict(imageBytes);
/// print('Found ${results.detections.length} objects');
/// print('Processing took ${results.processingTimeMs}ms');
/// if (results.annotatedImage != null) {
///   // Display or save the annotated image
/// }
/// ```
class YOLODetectionResults {
  /// List of all objects detected in the image.
  ///
  /// Each [YOLOResult] in this list represents a single detected object
  /// with its location, classification, and confidence score.
  final List<YOLOResult> detections;

  /// The original image with detection visualizations overlaid.
  ///
  /// This annotated image includes bounding boxes, class labels,
  /// confidence scores, and other task-specific visualizations
  /// (masks for segmentation, keypoints for pose estimation).
  final Uint8List? annotatedImage;

  /// The time taken to process the image in milliseconds.
  ///
  /// This includes model inference time and post-processing,
  /// but excludes image preprocessing and annotation rendering.
  final double processingTimeMs;

  YOLODetectionResults({
    required this.detections,
    this.annotatedImage,
    required this.processingTimeMs,
  });

  /// Creates [YOLODetectionResults] from a map representation.
  ///
  /// This factory constructor deserializes results received from
  /// the platform channel. The map should contain:
  /// - 'detections': List of detection maps
  /// - 'annotatedImage': (optional) Uint8List of image data
  /// - 'processingTimeMs': double representing processing time
  factory YOLODetectionResults.fromMap(Map<dynamic, dynamic> map) {
    final detectionsData = map['detections'] as List<dynamic>?;
    // Extract the metadata map from the root event
    final Map<dynamic, dynamic> imageMeta = map['originalImageSize'] ?? {};
    final detections = detectionsData != null
        ? detectionsData
              .map((detection) => YOLOResult.fromMap(detection, imageMeta))
              .toList()
        : <YOLOResult>[];

    final annotatedImage = MapConverter.safeGetUint8List(map, 'annotatedImage');

    final processingTimeMs = MapConverter.safeGetDouble(
      map,
      'processingTimeMs',
    );

    return YOLODetectionResults(
      detections: detections,
      annotatedImage: annotatedImage,
      processingTimeMs: processingTimeMs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detections': detections.map((detection) => detection.toMap()).toList(),
      'annotatedImage': annotatedImage,
      'processingTimeMs': processingTimeMs,
      'originalImageSize': {
        'width': detections.isNotEmpty
            ? detections.first.originalImageWidth
            : 0.0,
        'height': detections.isNotEmpty
            ? detections.first.originalImageHeight
            : 0.0,
      },
    };
  }
}

/// Represents a point in 2D space.
///
/// Example:
/// ```dart
/// final point = Point(150.5, 200.0);
/// print('Point at (${point.x}, ${point.y})');
/// ```
class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  Map<String, double> toMap() => {'x': x, 'y': y};

  factory Point.fromMap(Map<dynamic, dynamic> map) {
    return Point(
      MapConverter.safeGetDouble(map, 'x'),
      MapConverter.safeGetDouble(map, 'y'),
    );
  }

  @override
  String toString() => 'Point($x, $y)';
}
