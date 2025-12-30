import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:ultralytics_yolo/yolo_streaming_config.dart';
import 'dart:io';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/data/datasources/local_model_data_source.dart';
import 'package:yolo/data/datasources/remote_model_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: YoloRepository)
class YoloRepositoryImpl implements YoloRepository {
  final LocalModelDataSource localModelDataSource;
  final RemoteModelDataSource remoteModelDataSource;

  YoloRepositoryImpl({
    required this.localModelDataSource,
    required this.remoteModelDataSource,
  });

  final YOLOViewController _yoloViewController = YOLOViewController();

  @override
  YOLOViewController get yoloViewController => _yoloViewController;

  @override
  Stream<ModelLoadingState> getModelPath(ModelType modelType) async* {
    String? modelPath = await localModelDataSource.getModelPath(modelType);

    if (modelPath != null) {
      // Adding a small delay for smooth transition even if model is cached
      await Future.delayed(const Duration(milliseconds: 500));
      yield ModelLoadingState.ready(modelPath);
    } else {
      yield const ModelLoadingState.loading(0.0);

      try {
        final downloadStream = remoteModelDataSource.downloadModel(modelType);
        await for (final progress in downloadStream) {
          if (progress.error != null) {
            yield ModelLoadingState.error(
              progress.error?.toString() ?? 'Unknown download error',
            );
            return; // Stop streaming on error
          }
          if (progress.isCompleted && progress.data != null) {
            final isZip = Platform.isIOS; // iOS mlpackage comes as zip
            modelPath = await localModelDataSource.saveModel(
              modelType,
              progress.data!,
              isZip,
            );
            yield ModelLoadingState.ready(modelPath);
          } else {
            yield ModelLoadingState.loading(progress.progress);
          }
        }
      } catch (e) {
        yield ModelLoadingState.error(e.toString());
      }
    }
  }

  @override
  Future<void> setZoomLevel(double zoomLevel) async {
    await _yoloViewController.setZoomLevel(zoomLevel);
  }

  @override
  Future<void> flipCamera() async {
    await _yoloViewController.switchCamera();
  }

  @override
  Future<void> setConfidenceThreshold(double threshold) async {
    _yoloViewController.setConfidenceThreshold(threshold);
  }

  @override
  Future<void> setIoUThreshold(double threshold) async {
    await _yoloViewController.setIoUThreshold(threshold);
  }

  @override
  Future<void> setNumItemsThreshold(int threshold) async {
    await _yoloViewController.setNumItemsThreshold(threshold);
  }

  @override
  Future<void> setThresholds({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  }) async {
    await _yoloViewController.setThresholds(
      confidenceThreshold: confidenceThreshold,
      iouThreshold: iouThreshold,
      numItemsThreshold: numItemsThreshold,
    );
  }

  @override
  Future<void> setStreamingConfig(SystemHealthState healthState) async {
    switch (healthState) {
      case SystemHealthState.normal:
        await _yoloViewController.setStreamingConfig(
          const YOLOStreamingConfig.minimal(),
        );
        break;
      case SystemHealthState.warning:
        await _yoloViewController.setStreamingConfig(
          const YOLOStreamingConfig.powerSaving(),
        );
        break;
      case SystemHealthState.critical:
        await _yoloViewController.setStreamingConfig(
          const YOLOStreamingConfig.powerSaving(),
        );
        break;
    }
  }
}
