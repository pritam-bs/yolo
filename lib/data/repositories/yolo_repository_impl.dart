import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'dart:io';
import 'package:yolo/domain/entities/models.dart';
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
  void setZoomLevel(double zoomLevel) {
    _yoloViewController.setZoomLevel(zoomLevel);
  }

  @override
  void flipCamera() {
    _yoloViewController.switchCamera();
  }

  @override
  void setConfidenceThreshold(double threshold) {
    _yoloViewController.setConfidenceThreshold(threshold);
  }

  @override
  void setIoUThreshold(double threshold) {
    _yoloViewController.setIoUThreshold(threshold);
  }

  @override
  void setNumItemsThreshold(int threshold) {
    _yoloViewController.setNumItemsThreshold(threshold);
  }

  @override
  void setThresholds({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  }) {
    _yoloViewController.setThresholds(
      confidenceThreshold: confidenceThreshold,
      iouThreshold: iouThreshold,
      numItemsThreshold: numItemsThreshold,
    );
  }
}
