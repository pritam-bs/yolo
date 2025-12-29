import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultralytics_yolo/yolo_streaming_config.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/mappers/yolo_result_mapper.dart';
import 'package:yolo/domain/entities/detection_result.dart';
import 'package:yolo/domain/entities/models.dart';

/// Main content widget that handles the camera view and loading states
class CameraInferenceContent extends StatelessWidget {
  const CameraInferenceContent({
    super.key,
    required this.modelPath,
    required this.modelType,
    required this.onResult,
    required this.yoloViewController,
    required this.currentLensFacing,
    required this.confidenceThreshold,
    required this.iouThreshold,
  });

  final String? modelPath;
  final ModelType modelType;
  final Function(List<DetectionResult>) onResult;
  final YOLOViewController yoloViewController;
  final LensFacing currentLensFacing;
  final double confidenceThreshold;
  final double iouThreshold;

  @override
  Widget build(BuildContext context) {
    if (modelPath != null) {
      return YOLOView(
        key: ValueKey('yolo_view_${modelPath}_${modelType.task.name}'),
        controller: yoloViewController,
        modelPath: modelPath!,
        task: modelType.task,
        streamingConfig: const YOLOStreamingConfig.minimal(),
        useGpu: true,
        lensFacing: currentLensFacing,
        showOverlays: true,
        confidenceThreshold: confidenceThreshold,
        iouThreshold: iouThreshold,
        onResult: (results) {
          final detections = results.map((e) => e.toDetectionResult()).toList();
          onResult(detections);
        },
        onPerformanceMetrics: (metrics) {
          context.read<CameraInferenceBloc>().add(UpdateFps(metrics.fps));
        },
        onZoomChanged: (zoom) {
          context.read<CameraInferenceBloc>().add(SetZoomLevel(zoom));
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
