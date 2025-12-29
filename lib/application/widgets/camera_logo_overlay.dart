import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';

/// Center logo overlay widget
class CameraLogoOverlay extends StatelessWidget {
  const CameraLogoOverlay({super.key, required this.isLandscape});

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraInferenceBloc, CameraInferenceState>(
      builder: (context, state) {
        if (state.status.when(
          initial: () => false,
          loading: () => false,
          modelDownloading: (progress) => false,
          success: () => true,
          failure: (message) => false,
        )) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: isLandscape ? 0.3 : 0.5,
                heightFactor: isLandscape ? 0.3 : 0.5,
                child: Image.asset(
                  'assets/logo.png',
                  color: Colors.white.withAlpha(100),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
