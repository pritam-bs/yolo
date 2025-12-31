// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

import 'package:flutter/material.dart';
import 'package:yolo/domain/entities/models.dart';
import 'control_button.dart';

/// A widget containing camera control buttons
class CameraControls extends StatelessWidget {
  const CameraControls({
    super.key,
    required this.currentZoomLevel,
    required this.isFrontCamera,
    required this.activeSlider,
    required this.onZoomChanged,
    required this.onSliderToggled,
    required this.onCameraFlipped,
    required this.isLandscape,
  });

  final double currentZoomLevel;
  final bool isFrontCamera;
  final InferenceParameter activeSlider;
  final ValueChanged<double> onZoomChanged;
  final ValueChanged<InferenceParameter> onSliderToggled;
  final VoidCallback onCameraFlipped;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: isLandscape ? 16 : 32,
          right: isLandscape ? 8 : 16,
          child: Column(
            children: [
              if (!isFrontCamera)
                ControlButton(
                  content: '${currentZoomLevel.toStringAsFixed(1)}x',
                  onPressed: () => onZoomChanged(
                    currentZoomLevel < 0.75
                        ? 1.0
                        : currentZoomLevel < 2.0
                        ? 3.0
                        : 0.5,
                  ),
                ),
              SizedBox(height: isLandscape ? 8 : 12),
              ControlButton(
                content: Icons.layers,
                onPressed: () => onSliderToggled(InferenceParameter.numItems),
              ),
              SizedBox(height: isLandscape ? 8 : 12),
              ControlButton(
                content: Icons.adjust,
                onPressed: () => onSliderToggled(InferenceParameter.confidence),
              ),
              SizedBox(height: isLandscape ? 8 : 12),
              ControlButton(
                content: 'assets/iou.png',
                onPressed: () => onSliderToggled(InferenceParameter.iou),
              ),
              SizedBox(height: isLandscape ? 16 : 40),
            ],
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).padding.top + (isLandscape ? 32 : 16),
          left: isLandscape ? 32 : 16,
          child: CircleAvatar(
            radius: isLandscape ? 20 : 24,
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
              onPressed: onCameraFlipped,
            ),
          ),
        ),
      ],
    );
  }
}
