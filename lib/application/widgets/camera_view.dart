import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'camera_controls.dart';
import 'camera_inference_content.dart';
import 'camera_inference_overlay.dart';
import 'threshold_slider.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final state = context.watch<CameraInferenceBloc>().state;
    final getIt = GetIt.instance;

    return Stack(
      children: [
        CameraInferenceContent(
          modelPath: state.modelPath,
          modelType: state.modelType,
          onResult: (detections) => context.read<CameraInferenceBloc>().add(
            DetectionsOccurred(detections),
          ),
          yoloViewController: getIt<YoloRepository>().yoloViewController,
          currentLensFacing: state.currentLensFacing,
          confidenceThreshold: state.confidenceThreshold,
          iouThreshold: state.iouThreshold,
        ),
        // YOLOOverlay(
        //   detections: state.detections
        //       .map((e) => DetectionMapper.toYOLOResult(e))
        //       .toList(),
        // ),
        CameraInferenceOverlay(
          isLandscape: isLandscape,
          currentFps: state.currentFps,
        ),
        CameraControls(
          currentZoomLevel: state.currentZoomLevel,
          isFrontCamera: state.currentLensFacing == LensFacing.front,
          activeSlider: state.activeSlider,
          onZoomChanged: (zoom) =>
              context.read<CameraInferenceBloc>().add(SetZoomLevel(zoom)),
          onSliderToggled: (type) =>
              context.read<CameraInferenceBloc>().add(ToggleSlider(type)),
          onCameraFlipped: () =>
              context.read<CameraInferenceBloc>().add(const FlipCamera()),
          isLandscape: isLandscape,
        ),
        ThresholdSlider(
          activeSlider: state.activeSlider,
          confidenceThreshold: state.confidenceThreshold,
          iouThreshold: state.iouThreshold,
          numItemsThreshold: state.numItemsThreshold,
          onValueChanged: (value) {
            switch (state.activeSlider) {
              case SliderType.confidence:
                context.read<CameraInferenceBloc>().add(
                  UpdateConfidenceThreshold(value),
                );
                break;
              case SliderType.iou:
                context.read<CameraInferenceBloc>().add(
                  UpdateIouThreshold(value),
                );
                break;
              case SliderType.numItems:
                context.read<CameraInferenceBloc>().add(
                  UpdateNumItemsThreshold(value.toInt()),
                );
                break;
              default:
            }
          },
          isLandscape: isLandscape,
        ),
      ],
    );
  }
}
