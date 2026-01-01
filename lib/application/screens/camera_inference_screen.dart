import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';

import 'package:yolo/application/widgets/camera_view.dart';
import 'package:yolo/application/widgets/model_loading_overlay.dart';

/// A screen that demonstrates real-time YOLO inference using the device camera.
class CameraInferenceScreen extends StatefulWidget {
  const CameraInferenceScreen({super.key});

  @override
  State<CameraInferenceScreen> createState() => _CameraInferenceScreenState();
}

class _CameraInferenceScreenState extends State<CameraInferenceScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<CameraInferenceBloc>().add(const ResumeCamera());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraInferenceBloc, CameraInferenceState>(
      listenWhen: (previous, current) => previous.showAlert != current.showAlert,
      listener: (context, state) {
        if (state.showAlert) {
          final bloc = context.read<CameraInferenceBloc>();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Average Performance Metrics'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'Avg. Processing Time: ${state.averageProcessingTime?.toStringAsFixed(1) ?? 'N/A'}ms',
                      ),
                      Text(
                        'Avg. FPS: ${state.averageFps?.toStringAsFixed(1) ?? 'N/A'}',
                      ),
                      Text(
                        'Avg. RAM Usage: ${(state.averageRamUsage != null ? state.averageRamUsage! * 100 : 0.0).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      bloc.add(const ResetAlert());
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<CameraInferenceBloc, CameraInferenceState>(
          builder: (context, state) {
            final isModelReady = state.status.maybeWhen(
              success: () => true,
              orElse: () => false,
            );

            return Stack(
              children: [
                if (isModelReady) const CameraView(),
                if (!isModelReady) const ModelLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }
}
