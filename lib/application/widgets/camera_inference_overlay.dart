import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/domain/entities/models.dart';
import 'detection_stats_display.dart';
import 'model_selector.dart';
import 'threshold_pill.dart';

/// Top overlay widget containing model selector, stats, and threshold pills
class CameraInferenceOverlay extends StatelessWidget {
  const CameraInferenceOverlay({
    super.key,
    required this.isLandscape,
    required this.currentFps,
  });

  final bool isLandscape;
  final double currentFps;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraInferenceBloc, CameraInferenceState>(
      builder: (context, state) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + (isLandscape ? 8 : 16),
          left: isLandscape ? 8 : 16,
          right: isLandscape ? 8 : 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ModelSelector(
                selectedModel: state.modelType,
                isModelLoading: state.status.when(
                  initial: () => false,
                  loading: () => true,
                  modelLoading: (progress) => true,
                  success: () => false,
                  failure: (message) => false,
                ),
                onModelChanged: (model) =>
                    context.read<CameraInferenceBloc>().add(ChangeModel(model)),
              ),
              SizedBox(height: isLandscape ? 8 : 12),
              DetectionStatsDisplay(
                detectionCount: state.detections.length,
                currentFps: currentFps,
              ),
              const SizedBox(height: 8),
              _buildThresholdPills(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThresholdPills(CameraInferenceState state) {
    if (state.activeSlider == SliderType.confidence) {
      return ThresholdPill(
        label:
            'CONFIDENCE THRESHOLD: ${state.confidenceThreshold.toStringAsFixed(2)}',
      );
    } else if (state.activeSlider == SliderType.iou) {
      return ThresholdPill(
        label: 'IOU THRESHOLD: ${state.iouThreshold.toStringAsFixed(2)}',
      );
    } else if (state.activeSlider == SliderType.numItems) {
      return ThresholdPill(label: 'ITEMS MAX: ${state.numItemsThreshold}');
    }
    return const SizedBox.shrink();
  }
}
