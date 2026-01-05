import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultralytics_yolo/yolo_streaming_config.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/application/mappers/model_type_ui_mapper.dart';
import 'package:yolo/data/mappers/yolo_result_mapper.dart';
import 'package:yolo/domain/entities/detection_result.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/injection.dart';

/// Main content widget that handles the camera view and loading states
class CameraInferenceContent extends StatelessWidget {
  const CameraInferenceContent({
    super.key,
    required this.modelPath,
    required this.modelType,
    required this.onResult,
    required this.currentLensFacing,
    required this.confidenceThreshold,
    required this.iouThreshold,
  });

  final String? modelPath;
  final ModelType modelType;
  final Function(List<DetectionResult>) onResult;
  final LensFacing currentLensFacing;
  final double confidenceThreshold;
  final double iouThreshold;

  @override
  Widget build(BuildContext context) {
    if (modelPath != null) {
      return BlocConsumer<CameraInferenceBloc, CameraInferenceState>(
        listenWhen: (previous, current) =>
            previous.systemHealthState != current.systemHealthState,
        listener: (context, state) {
          final snackBarMessage = switch (state.systemHealthState) {
            SystemHealthState.normal => 'YOLO running in Normal mode.',
            SystemHealthState.warning => 'YOLO running in Warning mode.',
            SystemHealthState.critical => 'YOLO running in Critical mode.',
          };

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackBarMessage),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        builder: (context, state) {
          return YOLOView(
            key: ValueKey('yolo_view_${modelPath}_${modelType.name}'),
            controller: getIt<YOLOViewController>(), // Shared Singleton
            modelPath: modelPath!,
            task: modelType.toYoloTask,
            streamingConfig: const YOLOStreamingConfig.highPerformance(),
            useGpu: true,
            preferredDelegate: TFLiteAccelerationDelegate.gpu,
            lensFacing: currentLensFacing,
            showOverlays: true,
            confidenceThreshold: confidenceThreshold,
            iouThreshold: iouThreshold,
            onResult: (results) {
              final detections = results
                  .map((e) => e.toDetectionResult())
                  .toList();
              onResult(detections);
            },
            onPerformanceMetrics: (metrics) {
              context.read<CameraInferenceBloc>().add(
                UpdatePerformanceMetrics(metrics),
              );
            },
            onZoomChanged: (zoom) {
              context.read<CameraInferenceBloc>().add(SetZoomLevel(zoom));
            },
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
