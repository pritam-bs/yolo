import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart'
    as events;

class ModelLoadingOverlay extends StatelessWidget {
  const ModelLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraInferenceBloc, CameraInferenceState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final Widget? contentWidget = state.status.when(
          initial: () => null,
          loading: () => _buildLoadingWidget(context, 'Loading Model...'),
          modelDownloading: (progress) =>
              _buildDownloadingWidget(context, progress),
          success: () => null,
          failure: (message) => _buildErrorWidget(context, message),
        );

        if (contentWidget == null) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Card(
            margin: const EdgeInsets.all(32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: contentWidget,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget(BuildContext context, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text('Please wait...', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildDownloadingWidget(BuildContext context, double progress) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Downloading Model',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 16),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'This may take a few moments.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text('Error', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            context.read<CameraInferenceBloc>().add(
              const events.RetryModelDownload(),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text('Retry Download'),
        ),
      ],
    );
  }
}
