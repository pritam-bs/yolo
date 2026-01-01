import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'
    show verify, verifyNever, when, any, untilCalled;
import 'package:yolo/data/datasources/download_progress.dart';
import 'package:yolo/data/repositories/yolo_repository_impl.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../mocks.mocks.dart';

void main() {
  late YoloRepositoryImpl repository;
  late MockLocalModelDataSource mockLocalModelDataSource;
  late MockRemoteModelDataSource mockRemoteModelDataSource;
  late MockYOLOViewController mockYOLOViewController;

  setUp(() {
    mockLocalModelDataSource = MockLocalModelDataSource();
    mockRemoteModelDataSource = MockRemoteModelDataSource();
    mockYOLOViewController = MockYOLOViewController();
    repository = YoloRepositoryImpl(
      localModelDataSource: mockLocalModelDataSource,
      remoteModelDataSource: mockRemoteModelDataSource,
      yoloViewController: mockYOLOViewController,
    );
  });

  group('getModelPath', () {
    const ModelType testModelType = ModelType.detect;
    const String cachedModelPath = '/path/to/cached_model.pt';
    final Uint8List modelBytes = Uint8List.fromList(
      List.generate(100, (index) => index),
    );

    test(
      'WHEN localModelDataSource returns a path, THEN stream should yield ModelLoadingState.ready and never call the remote source',
      () async {
        when(
          mockLocalModelDataSource.getModelPath(testModelType),
        ).thenAnswer((_) async => cachedModelPath);

        final stream = repository.getModelPath(testModelType);

        expect(
          stream,
          emitsInOrder([
            const ModelLoadingState.ready(cachedModelPath),
            emitsDone,
          ]),
        );

        // Verify remote source was never called
        verifyNever(mockRemoteModelDataSource.downloadModel(any));
      },
    );

    test(
      'WHEN localModelDataSource returns null, THEN repository should initiate a download and yield loading states followed by ready',
      () async {
        when(
          mockLocalModelDataSource.getModelPath(testModelType),
        ).thenAnswer((_) async => null);
        when(mockRemoteModelDataSource.downloadModel(testModelType)).thenAnswer(
          (_) => Stream.fromIterable([
            const DownloadProgress(
              progress: 0.5,
              isCompleted: false,
              data: null,
            ),
            DownloadProgress(
              progress: 1.0,
              isCompleted: true,
              data: modelBytes,
            ),
          ]),
        );
        when(
          mockLocalModelDataSource.saveModel(testModelType, modelBytes, any),
        ).thenAnswer((_) async => cachedModelPath);

        final stream = repository.getModelPath(testModelType);

        expect(
          stream,
          emitsInOrder([
            const ModelLoadingState.loading(0.0),
            const ModelLoadingState.loading(0.5),
            const ModelLoadingState.ready(cachedModelPath),
            emitsDone,
          ]),
        );

        await untilCalled(
          mockRemoteModelDataSource.downloadModel(testModelType),
        );
        verify(
          mockRemoteModelDataSource.downloadModel(testModelType),
        ).called(1);
        await untilCalled(
          mockLocalModelDataSource.saveModel(testModelType, modelBytes, any),
        );
        verify(
          mockLocalModelDataSource.saveModel(testModelType, modelBytes, any),
        ).called(1);
      },
    );

    test(
      'WHEN remoteModelDataSource.downloadModel yields an error, THEN the repository stream must yield ModelLoadingState.error and stop',
      () async {
        when(
          mockLocalModelDataSource.getModelPath(testModelType),
        ).thenAnswer((_) async => null);
        final Exception downloadError = Exception('Network error');
        when(mockRemoteModelDataSource.downloadModel(testModelType)).thenAnswer(
          (_) => Stream.fromIterable([
            const DownloadProgress(
              progress: 0.5,
              isCompleted: false,
              data: null,
            ),
            DownloadProgress(
              progress: 0.0,
              error: downloadError,
              isCompleted: false,
              data: null,
            ),
          ]),
        );

        final stream = repository.getModelPath(testModelType);

        expect(
          stream,
          emitsInOrder([
            const ModelLoadingState.loading(0.0),
            const ModelLoadingState.loading(0.5),
            ModelLoadingState.error(downloadError.toString()),
            emitsDone,
          ]),
        );

        await untilCalled(
          mockRemoteModelDataSource.downloadModel(testModelType),
        );
        verify(
          mockRemoteModelDataSource.downloadModel(testModelType),
        ).called(1);
        verifyNever(mockLocalModelDataSource.saveModel(any, any, any));
      },
    );

    test(
      'WHEN remoteModelDataSource.downloadModel throws an exception, THEN the repository stream must yield ModelLoadingState.error and stop',
      () async {
        when(
          mockLocalModelDataSource.getModelPath(testModelType),
        ).thenAnswer((_) async => null);
        final Exception thrownError = Exception(
          'Unexpected error during download',
        );
        when(
          mockRemoteModelDataSource.downloadModel(testModelType),
        ).thenAnswer((_) => Stream.error(thrownError));

        final stream = repository.getModelPath(testModelType);

        expect(
          stream,
          emitsInOrder([
            const ModelLoadingState.loading(0.0),
            ModelLoadingState.error(thrownError.toString()),
            emitsDone,
          ]),
        );

        await untilCalled(
          mockRemoteModelDataSource.downloadModel(testModelType),
        );
        verify(
          mockRemoteModelDataSource.downloadModel(testModelType),
        ).called(1);
        verifyNever(mockLocalModelDataSource.saveModel(any, any, any));
      },
    );

    test(
      'WHEN a download completes, THEN localModelDataSource.saveModel is called with the correct bytes and platform-specific isZip flag',
      () async {
        when(
          mockLocalModelDataSource.getModelPath(testModelType),
        ).thenAnswer((_) async => null);
        when(mockRemoteModelDataSource.downloadModel(testModelType)).thenAnswer(
          (_) => Stream.fromIterable([
            DownloadProgress(
              progress: 1.0,
              isCompleted: true,
              data: modelBytes,
            ),
          ]),
        );
        when(
          mockLocalModelDataSource.saveModel(testModelType, modelBytes, any),
        ).thenAnswer((_) async => cachedModelPath);

        await repository
            .getModelPath(testModelType)
            .last; // Await the stream completion

        await untilCalled(
          mockLocalModelDataSource.saveModel(testModelType, modelBytes, any),
        );
        verify(
          mockLocalModelDataSource.saveModel(
            testModelType,
            modelBytes,
            Platform.isIOS,
          ),
        ).called(1);
      },
    );
  });

  group('setStreamingConfig', () {
    test(
      'Verify that SystemHealthState.critical correctly triggers YOLOStreamingConfig.powerSaving()',
      () async {
        when(
          mockYOLOViewController.setStreamingConfig(any),
        ).thenAnswer((_) async => {});

        await repository.setStreamingConfig(SystemHealthState.critical);

        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.powerSaving(),
          ),
        ).called(1);
      },
    );

    test(
      'Verify that SystemHealthState.warning correctly triggers YOLOStreamingConfig.lowPerformance()',
      () async {
        when(
          mockYOLOViewController.setStreamingConfig(any),
        ).thenAnswer((_) async => {});

        await repository.setStreamingConfig(SystemHealthState.warning);

        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.lowPerformance(),
          ),
        ).called(1);
      },
    );

    test(
      'Verify that SystemHealthState.normal correctly triggers YOLOStreamingConfig.highPerformance()',
      () async {
        when(
          mockYOLOViewController.setStreamingConfig(any),
        ).thenAnswer((_) async => {});

        await repository.setStreamingConfig(SystemHealthState.normal);

        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.highPerformance(),
          ),
        ).called(1);
      },
    );
  });
}
