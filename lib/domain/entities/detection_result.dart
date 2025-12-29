import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:ui';

part 'detection_result.freezed.dart';

@freezed
abstract class DetectionResult with _$DetectionResult {
  const factory DetectionResult({
    required Size imageSize,
    required Rect box,
    required Rect normalizedBox,
    required double score,
    required String label,
    required int classId,
  }) = _DetectionResult;
}
