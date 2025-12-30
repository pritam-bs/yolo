import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo/yolo_streaming_config.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart'
    hide FlipCamera, SetZoomLevel;
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/entities/system_metrics.dart';
import 'package:yolo/domain/usecases/flip_camera.dart';
import 'package:yolo/domain/usecases/get_model_path.dart';
import 'package:yolo/domain/usecases/get_system_metrics.dart';
import 'package:yolo/domain/usecases/set_confidence_threshold.dart';
import 'package:yolo/domain/usecases/set_iou_threshold.dart';
import 'package:yolo/domain/usecases/set_num_items_threshold.dart';
import 'package:yolo/domain/usecases/set_streaming_config.dart';
import 'package:yolo/domain/usecases/set_thresholds.dart';
import 'package:yolo/domain/usecases/set_zoom_level.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_dispose.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_start.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_stop.dart';

import 'camera_inference_bloc_test.mocks.dart';

@GenerateMocks([
  GetModelPath,
  FlipCamera,
  SetConfidenceThreshold,
  SetIoUThreshold,
  SetNumItemsThreshold,
  SetZoomLevel,
  SetThresholds,
  GetSystemMetrics,
  SystemMetricsMonitorStart,
  SystemMetricsMonitorDispose,
  SystemMetricsMonitorStop, // Keep this for verification in close()
  SetStreamingConfig,
])
void main() {
  late CameraInferenceBloc cameraInferenceBloc;
  late MockGetModelPath mockGetModelPath;
  late MockFlipCamera mockFlipCamera;
  late MockSetConfidenceThreshold mockSetConfidenceThreshold;
  late MockSetIoUThreshold mockSetIoUThreshold;
  late MockSetNumItemsThreshold mockSetNumItemsThreshold;
  late MockSetZoomLevel mockSetZoomLevel;
  late MockSetThresholds mockSetThresholds;
  late MockSetStreamingConfig mockSetStreamingConfig;
  late MockGetSystemMetrics mockGetSystemMetrics;
  late MockSystemMetricsMonitorStart mockSystemMetricsMonitorStart;
  late MockSystemMetricsMonitorStop mockSystemMetricsMonitorStop;
  late MockSystemMetricsMonitorDispose mockSystemMetricsMonitorDispose;

  setUp(() {
    mockGetModelPath = MockGetModelPath();
    mockFlipCamera = MockFlipCamera();
    mockSetConfidenceThreshold = MockSetConfidenceThreshold();
    mockSetIoUThreshold = MockSetIoUThreshold();
    mockSetNumItemsThreshold = MockSetNumItemsThreshold();
    mockSetZoomLevel = MockSetZoomLevel();
    mockSetThresholds = MockSetThresholds();
    mockSetStreamingConfig = MockSetStreamingConfig();
    mockGetSystemMetrics = MockGetSystemMetrics();
    mockSystemMetricsMonitorStart = MockSystemMetricsMonitorStart();
    mockSystemMetricsMonitorStop =
        MockSystemMetricsMonitorStop(); // Initialize mock
    mockSystemMetricsMonitorDispose = MockSystemMetricsMonitorDispose();

    when(
      mockGetModelPath(any),
    ).thenAnswer((_) => Stream.value(const ModelLoadingState.ready('path')));
    when(mockGetSystemMetrics()).thenAnswer((_) => const Stream.empty());
    when(mockSetStreamingConfig(any)).thenReturn(null);
    when(mockSetThresholds(
      confidenceThreshold: anyNamed('confidenceThreshold'),
      iouThreshold: anyNamed('iouThreshold'),
      numItemsThreshold: anyNamed('numItemsThreshold'),
    )).thenReturn(null);

    cameraInferenceBloc = CameraInferenceBloc(
      getModelPath: mockGetModelPath,
      flipCamera: mockFlipCamera,
      setConfidenceThreshold: mockSetConfidenceThreshold,
      setIoUThreshold: mockSetIoUThreshold,
      setNumItemsThreshold: mockSetNumItemsThreshold,
      setZoomLevel: mockSetZoomLevel,
      setThresholds: mockSetThresholds,
      setStreamingConfig: mockSetStreamingConfig,
      getSystemMetrics: mockGetSystemMetrics,
      systemMetricsMonitorStart: mockSystemMetricsMonitorStart,
      systemMetricsMonitorStop:
          mockSystemMetricsMonitorStop, // Pass mock to constructor
      systemMetricsMonitorDispose: mockSystemMetricsMonitorDispose,
    );
  });

  tearDown(() {
    cameraInferenceBloc.close();
  });

  test('initial state is correct', () {
    expect(cameraInferenceBloc.state, const CameraInferenceState());
  });

  group('System Monitor', () {
    blocTest<CameraInferenceBloc, CameraInferenceState>(
      'starts system monitor when model is ready',
      build: () => cameraInferenceBloc,
      act: (bloc) => bloc.add(const CameraInferenceEvent.initializeCamera()),
      verify: (_) {
        verify(mockSystemMetricsMonitorStart()).called(1);
      },
    );

    blocTest<CameraInferenceBloc, CameraInferenceState>(
      'emits correct health states and calls use cases when system metrics change',
      build: () {
        when(mockGetSystemMetrics()).thenAnswer(
          (_) => Stream.fromIterable([
            const SystemMetrics(
              batteryLevel: 100,
              ramUsage: 50,
              thermalState: ThermalState.nominal,
            ),
            const SystemMetrics(
              batteryLevel: 100,
              ramUsage: 75,
              thermalState: ThermalState.nominal,
            ),
            const SystemMetrics(
              batteryLevel: 100,
              ramUsage: 90,
              thermalState: ThermalState.nominal,
            ),
            const SystemMetrics(
              batteryLevel: 100,
              ramUsage: 60,
              thermalState: ThermalState.serious,
            ),
            const SystemMetrics(
              batteryLevel: 100,
              ramUsage: 60,
              thermalState: ThermalState.critical,
            ),
          ]),
        );
        return cameraInferenceBloc;
      },
      act: (bloc) => bloc.add(const CameraInferenceEvent.startSystemMonitor()),
      expect: () => [
        isA<CameraInferenceState>().having(
          (s) => s.systemHealthState,
          'state',
          SystemHealthState.warning,
        ),
        isA<CameraInferenceState>().having(
          (s) => s.systemHealthState,
          'state',
          SystemHealthState.critical,
        ),
        isA<CameraInferenceState>().having(
          (s) => s.systemHealthState,
          'state',
          SystemHealthState.warning,
        ),
        isA<CameraInferenceState>().having(
          (s) => s.systemHealthState,
          'state',
          SystemHealthState.critical,
        ),
      ],
      verify: (_) {
        // Verify Normal state calls
        verify(mockSetStreamingConfig(const YOLOStreamingConfig.highPerformance()))
            .called(1);
        verify(mockSetThresholds(
          confidenceThreshold: 0.5,
          iouThreshold: 0.45,
          numItemsThreshold: 30,
        )).called(1);

        // Verify Warning state calls
        verify(mockSetStreamingConfig(const YOLOStreamingConfig.powerSaving()))
            .called(2); // Called for ramUsage 75 and thermalState serious
        verify(mockSetThresholds(
          confidenceThreshold: 0.4,
          iouThreshold: 0.5,
          numItemsThreshold: 20,
        )).called(2);

        // Verify Critical state calls
        verify(mockSetStreamingConfig(const YOLOStreamingConfig.powerSaving()))
            .called(2); // Called for ramUsage 90 and thermalState critical
        verify(mockSetThresholds(
          confidenceThreshold: 0.3,
          iouThreshold: 0.6,
          numItemsThreshold: 10,
        )).called(2);
      },
    );

    test('disposes system monitor when bloc is closed', () async {
      await cameraInferenceBloc.close();
      verify(mockSystemMetricsMonitorStop()).called(1); // Verify stop is called
      verify(mockSystemMetricsMonitorDispose()).called(1);
    });
  });
}
