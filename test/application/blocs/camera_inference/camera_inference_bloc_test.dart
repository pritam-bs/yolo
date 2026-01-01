import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:yolo/domain/entities/system_metrics.dart';

import '../../../mocks.mocks.dart';

void main() {
  group('CameraInferenceBloc', () {
    late MockGetModelPath mockGetModelPath;
    late MockSetConfidenceThreshold mockSetConfidenceThreshold;
    late MockSetIoUThreshold mockSetIoUThreshold;
    late MockSetNumItemsThreshold mockSetNumItemsThreshold;
    late MockSetThresholds mockSetThresholds;
    late MockSetStreamingConfig mockSetStreamingConfig;
    late MockGetSystemMetrics mockGetSystemMetrics;
    late MockSystemMetricsMonitorStart mockSystemMetricsMonitorStart;
    late MockSystemMetricsMonitorStop mockSystemMetricsMonitorStop;
    late MockSystemMetricsMonitorDispose mockSystemMetricsMonitorDispose;
    late MockYOLOViewController mockYOLOViewController;

    setUp(() {
      mockGetModelPath = MockGetModelPath();
      mockSetConfidenceThreshold = MockSetConfidenceThreshold();
      mockSetIoUThreshold = MockSetIoUThreshold();
      mockSetNumItemsThreshold = MockSetNumItemsThreshold();
      mockSetThresholds = MockSetThresholds();
      mockSetStreamingConfig = MockSetStreamingConfig();
      mockGetSystemMetrics = MockGetSystemMetrics();
      mockSystemMetricsMonitorStart = MockSystemMetricsMonitorStart();
      mockSystemMetricsMonitorStop = MockSystemMetricsMonitorStop();
      mockSystemMetricsMonitorDispose = MockSystemMetricsMonitorDispose();
      mockYOLOViewController = MockYOLOViewController();

      // Stub the call methods for the monitor stop and dispose use cases
      when(
        mockSystemMetricsMonitorStop(),
      ).thenAnswer((_) async => Future<void>.value());
      when(
        mockSystemMetricsMonitorDispose(),
      ).thenAnswer((_) async => Future<void>.value());
    });

    blocTest<CameraInferenceBloc, CameraInferenceState>(
      'reacts to critical system health states and applies power-saving config',
      build: () {
        when(mockGetSystemMetrics.call()).thenAnswer(
          (_) => Stream.fromIterable([
            SystemMetrics(
              ramUsage: 0.5,
              thermalState: ThermalState.nominal,
              batteryLevel: 80,
            ),
            SystemMetrics(
              ramUsage: 0.96,
              thermalState: ThermalState.critical,
              batteryLevel: 5,
            ),
          ]),
        );
        return CameraInferenceBloc(
          getModelPath: mockGetModelPath,
          setConfidenceThreshold: mockSetConfidenceThreshold,
          setIoUThreshold: mockSetIoUThreshold,
          setNumItemsThreshold: mockSetNumItemsThreshold,
          setThresholds: mockSetThresholds,
          setStreamingConfig: mockSetStreamingConfig,
          getSystemMetrics: mockGetSystemMetrics,
          systemMetricsMonitorStart: mockSystemMetricsMonitorStart,
          systemMetricsMonitorStop: mockSystemMetricsMonitorStop,
          systemMetricsMonitorDispose: mockSystemMetricsMonitorDispose,
          yoloController: mockYOLOViewController,
        );
      },
      act: (bloc) => bloc.add(const CameraInferenceEvent.startSystemMonitor()),
      expect: () => [
        const CameraInferenceState(
          systemHealthState: SystemHealthState.critical,
          confidenceThreshold: 0.3,
          iouThreshold: 0.6,
          numItemsThreshold: 10,
        ),
      ],
      verify: (_) {
        verify(
          mockSystemMetricsMonitorStart(interval: const Duration(minutes: 5)),
        ).called(1);
        verify(mockSetStreamingConfig(SystemHealthState.critical)).called(1);
        verify(
          mockSetThresholds(
            confidenceThreshold: 0.3,
            iouThreshold: 0.6,
            numItemsThreshold: 10,
          ),
        ).called(1);
      },
    );

    blocTest<CameraInferenceBloc, CameraInferenceState>(
      'handles model loading states and transitions to ready on success',
      build: () {
        when(
          mockSystemMetricsMonitorStart(interval: anyNamed('interval')),
        ).thenAnswer(
          (_) async => Future<void>.value(),
        ); // Explicitly stubbing here for the first call

        when(mockGetSystemMetrics.call()).thenAnswer(
          (_) => Stream.fromIterable([
            SystemMetrics(
              ramUsage: 0.5,
              thermalState: ThermalState.nominal,
              batteryLevel: 80,
            ),
          ]),
        );
        when(mockGetModelPath.call(ModelType.detect)).thenAnswer(
          (_) => Stream.fromIterable([
            ModelLoadingState.loading(0.5),
            ModelLoadingState.ready('path/to/model'),
          ]),
        );
        final bloc = CameraInferenceBloc(
          getModelPath: mockGetModelPath,
          setConfidenceThreshold: mockSetConfidenceThreshold,
          setIoUThreshold: mockSetIoUThreshold,
          setNumItemsThreshold: mockSetNumItemsThreshold,
          setThresholds: mockSetThresholds,
          setStreamingConfig: mockSetStreamingConfig,
          getSystemMetrics: mockGetSystemMetrics,
          systemMetricsMonitorStart: mockSystemMetricsMonitorStart,
          systemMetricsMonitorStop: mockSystemMetricsMonitorStop,
          systemMetricsMonitorDispose: mockSystemMetricsMonitorDispose,
          yoloController: mockYOLOViewController,
        );
        clearInteractions(
          mockSystemMetricsMonitorStart,
        ); // Clear interactions after initial build
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const CameraInferenceEvent.changeModel(ModelType.detect)),
      expect: () => [
        const CameraInferenceState(
          status: CameraInferenceStatus.loading(),
          modelType: ModelType.detect,
        ),
        const CameraInferenceState(
          status: CameraInferenceStatus.modelDownloading(0.5),
          modelType: ModelType.detect,
        ),
        const CameraInferenceState(
          status: CameraInferenceStatus.success(),
          modelType: ModelType.detect,
          modelPath: 'path/to/model',
        ),
      ],
    );

    blocTest<CameraInferenceBloc, CameraInferenceState>(
      'flips camera and updates lens facing state',
      build: () {
        when(mockYOLOViewController.switchCamera()).thenAnswer((_) async {});
        return CameraInferenceBloc(
          getModelPath: mockGetModelPath,
          setConfidenceThreshold: mockSetConfidenceThreshold,
          setIoUThreshold: mockSetIoUThreshold,
          setNumItemsThreshold: mockSetNumItemsThreshold,
          setThresholds: mockSetThresholds,
          setStreamingConfig: mockSetStreamingConfig,
          getSystemMetrics: mockGetSystemMetrics,
          systemMetricsMonitorStart: mockSystemMetricsMonitorStart,
          systemMetricsMonitorStop: mockSystemMetricsMonitorStop,
          systemMetricsMonitorDispose: mockSystemMetricsMonitorDispose,
          yoloController: mockYOLOViewController,
        );
      },
      act: (bloc) => bloc.add(const CameraInferenceEvent.flipCamera()),
      expect: () => [
        const CameraInferenceState(
          currentLensFacing: LensFacing.front,
          currentZoomLevel: 1.0,
        ),
      ],
      verify: (_) {
        verify(mockYOLOViewController.switchCamera()).called(1);
      },
    );
  });
}
