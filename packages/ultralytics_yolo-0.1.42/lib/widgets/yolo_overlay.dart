// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/models/yolo_result.dart';

/// A widget that displays detection overlays on top of the camera view.
class YOLOOverlay extends StatelessWidget {
  final List<YOLOResult> detections;
  final bool showConfidence;
  final bool showClassName;
  final YOLOOverlayTheme theme;
  final void Function(YOLOResult detection)? onDetectionTap;

  const YOLOOverlay({
    super.key,
    required this.detections,
    this.showConfidence = true,
    this.showClassName = true,
    this.theme = const YOLOOverlayTheme(),
    this.onDetectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) =>
              _handleTap(details, context, constraints.biggest),
          child: CustomPaint(
            size: Size.infinite,
            painter: YOLODetectionPainter(
              detections: detections,
              showConfidence: showConfidence,
              showClassName: showClassName,
              theme: theme,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapDownDetails details, BuildContext context, Size size) {
    if (onDetectionTap == null) return;

    final localPosition = details.localPosition;

    for (final detection in detections) {
      // We must use the exact same scaling math used in the Painter
      final rect = _getMappedRect(detection, size);
      if (rect.contains(localPosition)) {
        onDetectionTap!(detection);
        break;
      }
    }
  }

  /// Centralized scaling logic to ensure Painter and Tap logic are in sync.
  Rect _getMappedRect(YOLOResult detection, Size size) {
    final double imgW = detection.originalImageWidth;
    final double imgH = detection.originalImageHeight;
    if (imgW <= 0 || imgH <= 0) return Rect.zero;

    final deviceRatio = size.width / size.height;
    final cameraRatio = imgW / imgH;

    double scale;
    double dx = 0;
    double dy = 0;

    if (deviceRatio > cameraRatio) {
      scale = size.width / imgW;
      dy = (size.height - imgH * scale) / 2;
    } else {
      scale = size.height / imgH;
      dx = (size.width - imgW * scale) / 2;
    }

    return Rect.fromLTRB(
      (detection.normalizedBox.left * imgW * scale) + dx,
      (detection.normalizedBox.top * imgH * scale) + dy,
      (detection.normalizedBox.right * imgW * scale) + dx,
      (detection.normalizedBox.bottom * imgH * scale) + dy,
    );
  }
}

/// Custom painter for drawing detection overlays.
class YOLODetectionPainter extends CustomPainter {
  final List<YOLOResult> detections;
  final bool showConfidence;
  final bool showClassName;
  final YOLOOverlayTheme theme;

  YOLODetectionPainter({
    required this.detections,
    required this.showConfidence,
    required this.showClassName,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections) {
      final rect = _getMappedRect(detection, size);
      if (rect == Rect.zero) continue;

      _drawDetection(canvas, rect, detection, size);
    }
  }

  /// Helper to calculate the screen rect (Matches the logic in the Widget)
  Rect _getMappedRect(YOLOResult detection, Size size) {
    final double imgW = detection.originalImageWidth;
    final double imgH = detection.originalImageHeight;
    if (imgW <= 0 || imgH <= 0) return Rect.zero;

    final deviceRatio = size.width / size.height;
    final cameraRatio = imgW / imgH;

    double scale;
    double dx = 0;
    double dy = 0;

    if (deviceRatio > cameraRatio) {
      scale = size.width / imgW;
      dy = (size.height - imgH * scale) / 2;
    } else {
      scale = size.height / imgH;
      dx = (size.width - imgW * scale) / 2;
    }

    return Rect.fromLTRB(
      (detection.normalizedBox.left * imgW * scale) + dx,
      (detection.normalizedBox.top * imgH * scale) + dy,
      (detection.normalizedBox.right * imgW * scale) + dx,
      (detection.normalizedBox.bottom * imgH * scale) + dy,
    );
  }

  void _drawDetection(
    Canvas canvas,
    Rect rect,
    YOLOResult detection,
    Size size,
  ) {
    // 1. Draw Bounding Box (Natural clipping, no shifting)
    final boxPaint = Paint()
      ..color = theme.boundingBoxColor
      ..strokeWidth = theme.boundingBoxWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      boxPaint,
    );

    // 2. Prepare Label Text
    if (showClassName || showConfidence) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: _buildLabelText(detection),
          style: TextStyle(
            color: theme.textColor,
            fontSize: theme.textSize,
            fontWeight: theme.textWeight,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const double padding = 4.0;
      final double lbWidth = textPainter.width + (padding * 2);
      final double lbHeight = textPainter.height + (padding * 2);

      // 3. Sticky Label Logic (Clamp to screen bounds)
      double lbLeft = rect.left;
      double lbTop = rect.top - lbHeight;

      // Handle vertical overflow: flip label inside box if it hits top of screen
      if (lbTop < 0) lbTop = rect.top.clamp(0, size.height);

      // Handle horizontal overflow: slide label left/right to stay on screen
      lbLeft = lbLeft.clamp(0, (size.width - lbWidth).clamp(0, size.width));

      final labelRect = Rect.fromLTWH(lbLeft, lbTop, lbWidth, lbHeight);

      // 4. Draw Label Background
      final bgPaint = Paint()..color = theme.labelBackgroundColor;
      canvas.drawRect(labelRect, bgPaint);

      // 5. Draw Label Text
      textPainter.paint(canvas, Offset(lbLeft + padding, lbTop + padding));
    }
  }

  String _buildLabelText(YOLOResult detection) {
    final parts = <String>[];
    if (showClassName) parts.add(detection.className);
    if (showConfidence) {
      parts.add('${(detection.confidence * 100).toStringAsFixed(1)}%');
    }
    return parts.join(' ');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Theme configuration for YOLO overlays.
class YOLOOverlayTheme {
  final Color boundingBoxColor;
  final double boundingBoxWidth;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;
  final Color labelBackgroundColor;

  const YOLOOverlayTheme({
    this.boundingBoxColor = Colors.red,
    this.boundingBoxWidth = 2.0,
    this.textColor = Colors.white,
    this.textSize = 12.0,
    this.textWeight = FontWeight.bold,
    this.labelBackgroundColor = Colors.black54,
  });
}
