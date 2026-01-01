import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/entities/system_metrics.dart';
import 'package:yolo/domain/usecases/get_model_path.dart';
import 'package:yolo/domain/usecases/get_system_metrics.dart';
import 'package:yolo/domain/usecases/set_confidence_threshold.dart';
import 'package:yolo/domain/usecases/set_iou_threshold.dart';
import 'package:yolo/domain/usecases/set_num_items_threshold.dart';
import 'package:yolo/domain/usecases/set_thresholds.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_dispose.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_start.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_stop.dart';
import 'package:yolo/domain/usecases/set_streaming_config.dart';
import 'camera_inference_event.dart' as events;
import 'camera_inference_state.dart';

@injectable
class CameraInferenceBloc
    extends Bloc<events.CameraInferenceEvent, CameraInferenceState> {
  final GetModelPath _getModelPath;
  final SetConfidenceThreshold _setConfidenceThreshold;
  final SetIoUThreshold _setIoUThreshold;
  final SetNumItemsThreshold _setNumItemsThreshold;
  final SetThresholds _setThresholds;
  final SetStreamingConfig _setStreamingConfig;
  final GetSystemMetrics _getSystemMetrics;
  final SystemMetricsMonitorStart _systemMetricsMonitorStart;
  final SystemMetricsMonitorStop _systemMetricsMonitorStop;
  final SystemMetricsMonitorDispose _systemMetricsMonitorDispose;
  // Direct Hardware Control (Shared Singleton)
  final YOLOViewController _yoloController;

  int _detectionCount = 0;
  int _frameCount = 0;
  double _currentFps = 0.0;
  DateTime _lastFpsUpdate;
  Timer? _performanceMonitorTimer;

  CameraInferenceBloc({
    required GetModelPath getModelPath,
    required SetConfidenceThreshold setConfidenceThreshold,
    required SetIoUThreshold setIoUThreshold,
    required SetNumItemsThreshold setNumItemsThreshold,
    required SetThresholds setThresholds,
    required SetStreamingConfig setStreamingConfig,
    required GetSystemMetrics getSystemMetrics,
    required SystemMetricsMonitorStart systemMetricsMonitorStart,
    required SystemMetricsMonitorStop systemMetricsMonitorStop,
    required SystemMetricsMonitorDispose systemMetricsMonitorDispose,
    required YOLOViewController yoloController,
  }) : _getModelPath = getModelPath,
       _setConfidenceThreshold = setConfidenceThreshold,
       _setIoUThreshold = setIoUThreshold,
       _setNumItemsThreshold = setNumItemsThreshold,
       _setThresholds = setThresholds,
       _setStreamingConfig = setStreamingConfig,
       _getSystemMetrics = getSystemMetrics,
       _systemMetricsMonitorStart = systemMetricsMonitorStart,
       _systemMetricsMonitorStop = systemMetricsMonitorStop,
       _systemMetricsMonitorDispose = systemMetricsMonitorDispose,
       _yoloController = yoloController,
       _lastFpsUpdate = DateTime.now(),
       super(const CameraInferenceState()) {
    on<events.InitializeCamera>(_onInitializeCamera);
    on<events.ChangeModel>(_onChangeModel);
    on<events.FlipCamera>(_onFlipCamera);
    on<events.SetZoomLevel>(_onSetZoomLevel);
    on<events.UpdateConfidenceThreshold>(_onUpdateConfidenceThreshold);
    on<events.UpdateIouThreshold>(_onUpdateIouThreshold);
    on<events.UpdateNumItemsThreshold>(_onUpdateNumItemsThreshold);
    on<events.DetectionsOccurred>(_onDetectionsOccurred);
    on<events.ToggleSlider>(_onToggleSlider);
    on<events.UpdateLensFacing>(_onUpdateLensFacing);
    on<events.RetryModelDownload>(_onRetryModelDownload);
    on<events.ResumeCamera>(_onResumeLayoutCamera);
    on<events.SetInitialConfig>(_onSetInitialConfig);
    on<events.StartSystemMonitor>(_onStartSystemMonitor);
    on<events.UpdatePerformanceMetrics>(_onUpdatePerformanceMetrics);
    on<events.ShowAveragePerformanceAlert>(_onShowAveragePerformanceAlert);
    on<events.ResetAlert>(_onResetAlert);
  }

  @override
  Future<void> close() async {
    _performanceMonitorTimer?.cancel();
    await _systemMetricsMonitorStop();
    await _systemMetricsMonitorDispose();
    return super.close();
  }

  void _startPerformanceMonitoring(Emitter<CameraInferenceState> emit) {
    if (state.monitoringStartTime == null) {
      emit(
        state.copyWith(
          monitoringStartTime: DateTime.now(),
          processingTimes: [],
          fpsValues: [],
          ramUsages: [],
          averageProcessingTime: null,
          averageFps: null,
          averageRamUsage: null,
          showAlert: false,
        ),
      );
      _performanceMonitorTimer = Timer(const Duration(minutes: 5), () {
        add(const events.CameraInferenceEvent.showAveragePerformanceAlert());
      });
    }
  }

  Future<void> _onStartSystemMonitor(
    events.StartSystemMonitor event,
    Emitter<CameraInferenceState> emit,
  ) async {
    // Start monitoring
    _systemMetricsMonitorStart(interval: const Duration(minutes: 5));

    await emit.onEach<SystemMetrics>(
      _getSystemMetrics(),
      onData: (metrics) async {
        final healthState = _determineHealthState(metrics);
        // Always add ramUsage to the list for averaging
        final newRamUsages = [...state.ramUsages, metrics.ramUsage];

        if (healthState != state.systemHealthState) {
          await _setStreamingConfig(healthState);

          switch (healthState) {
            case SystemHealthState.normal:
              _setThresholds(
                confidenceThreshold: 0.5,
                iouThreshold: 0.45,
                numItemsThreshold: 30,
              );

              emit(
                state.copyWith(
                  systemHealthState: healthState,
                  confidenceThreshold: 0.5,
                  iouThreshold: 0.45,
                  numItemsThreshold: 30,
                  ramUsages: newRamUsages,
                ),
              );
              break;
            case SystemHealthState.warning:
              _setThresholds(
                confidenceThreshold: 0.4,
                iouThreshold: 0.5,
                numItemsThreshold: 20,
              );

              emit(
                state.copyWith(
                  systemHealthState: healthState,
                  confidenceThreshold: 0.4,
                  iouThreshold: 0.5,
                  numItemsThreshold: 20,
                  ramUsages: newRamUsages,
                ),
              );
              break;
            case SystemHealthState.critical:
              _setThresholds(
                confidenceThreshold: 0.3,
                iouThreshold: 0.6,
                numItemsThreshold: 10,
              );

              emit(
                state.copyWith(
                  systemHealthState: healthState,
                  confidenceThreshold: 0.3,
                  iouThreshold: 0.6,
                  numItemsThreshold: 10,
                  ramUsages: newRamUsages,
                ),
              );
              break;
          }
        } else {
          // If health state doesn't change, just update ram usage
          emit(state.copyWith(ramUsages: newRamUsages));
        }
      },
    );
  }

  SystemHealthState _determineHealthState(SystemMetrics metrics) {
    if (metrics.ramUsage > 0.95 ||
        metrics.thermalState == ThermalState.critical ||
        metrics.batteryLevel < 10) {
      return SystemHealthState.critical;
    } else if (metrics.ramUsage > 0.85 ||
        metrics.thermalState == ThermalState.serious ||
        metrics.batteryLevel < 30) {
      return SystemHealthState.warning;
    } else {
      return SystemHealthState.normal;
    }
  }

  void _onUpdatePerformanceMetrics(
    events.UpdatePerformanceMetrics event,
    Emitter<CameraInferenceState> emit,
  ) {
    final newProcessingTimes = [
      ...state.processingTimes,
      event.metrics.processingTimeMs,
    ];
    final newFpsValues = [...state.fpsValues, event.metrics.fps];

    emit(
      state.copyWith(
        currentFps: event.metrics.fps,
        processingTimeMs: event.metrics.processingTimeMs,
        processingTimes: newProcessingTimes,
        fpsValues: newFpsValues,
      ),
    );
  }

  void _onShowAveragePerformanceAlert(
    events.ShowAveragePerformanceAlert event,
    Emitter<CameraInferenceState> emit,
  ) {
    _performanceMonitorTimer?.cancel(); // Stop the timer

    if (state.processingTimes.isEmpty ||
        state.fpsValues.isEmpty ||
        state.ramUsages.isEmpty) {
      emit(
        state.copyWith(
          showAlert: true,
          averageProcessingTime: 0.0,
          averageFps: 0.0,
          averageRamUsage: 0.0,
        ),
      );
      return;
    }

    final averageProcessingTime =
        state.processingTimes.reduce((a, b) => a + b) /
        state.processingTimes.length;
    final averageFps =
        state.fpsValues.reduce((a, b) => a + b) / state.fpsValues.length;
    final averageRamUsage =
        state.ramUsages.reduce((a, b) => a + b) / state.ramUsages.length;

    emit(
      state.copyWith(
        showAlert: true,
        averageProcessingTime: averageProcessingTime,
        averageFps: averageFps,
        averageRamUsage: averageRamUsage,
      ),
    );
  }

  void _onResetAlert(
    events.ResetAlert event,
    Emitter<CameraInferenceState> emit,
  ) {
    emit(
      state.copyWith(
        showAlert: false,
        monitoringStartTime: null,
        processingTimes: [],
        fpsValues: [],
        ramUsages: [],
        averageProcessingTime: null,
        averageFps: null,
        averageRamUsage: null,
      ),
    );
    _performanceMonitorTimer?.cancel(); // Ensure timer is cancelled on reset
  }

  void _onUpdateLensFacing(
    events.UpdateLensFacing event,
    Emitter<CameraInferenceState> emit,
  ) {
    emit(state.copyWith(currentLensFacing: event.lensFacing));
  }

  Future<void> _onInitializeCamera(
    events.InitializeCamera event,
    Emitter<CameraInferenceState> emit,
  ) async {
    emit(state.copyWith(status: const CameraInferenceStatus.loading()));
    _startPerformanceMonitoring(emit); // Start monitoring

    _setThresholds(
      confidenceThreshold: state.confidenceThreshold,
      iouThreshold: state.iouThreshold,
      numItemsThreshold: state.numItemsThreshold,
    );

    await _downloadModel(state.modelType, emit);
  }

  Future<void> _onChangeModel(
    events.ChangeModel event,
    Emitter<CameraInferenceState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const CameraInferenceStatus.loading(),
        modelType: event.model,
      ),
    );
    _startPerformanceMonitoring(emit); // Restart monitoring on model change

    _setThresholds(
      confidenceThreshold: state.confidenceThreshold,
      iouThreshold: state.iouThreshold,
      numItemsThreshold: state.numItemsThreshold,
    );

    await _downloadModel(event.model, emit);
  }

  Future<void> _onRetryModelDownload(
    events.RetryModelDownload event,
    Emitter<CameraInferenceState> emit,
  ) async {
    emit(state.copyWith(status: const CameraInferenceStatus.loading()));
    _startPerformanceMonitoring(emit); // Start monitoring
    await _downloadModel(state.modelType, emit);
  }

  Future<void> _onResumeLayoutCamera(
    events.ResumeCamera event,
    Emitter<CameraInferenceState> emit,
  ) async {
    if (state.status == const CameraInferenceStatus.initial() ||
        state.status.maybeWhen(failure: (_) => true, orElse: () => false)) {
      emit(state.copyWith(status: const CameraInferenceStatus.loading()));
      _startPerformanceMonitoring(emit); // Start monitoring
      await _downloadModel(state.modelType, emit);
    }
  }

  Future<void> _downloadModel(
    ModelType modelType,
    Emitter<CameraInferenceState> emit,
  ) async {
    // Use onEach instead of forEach
    await emit.onEach<ModelLoadingState>(
      _getModelPath(modelType),
      onData: (modelLoadingState) {
        modelLoadingState.when(
          initial: () {}, // No-op
          loading: (progress) {
            emit(
              state.copyWith(
                status: CameraInferenceStatus.modelDownloading(progress),
              ),
            );
          },
          ready: (modelPath) {
            // Update the state to success/ready
            emit(
              state.copyWith(
                status: const CameraInferenceStatus.success(),
                modelPath: modelPath,
              ),
            );

            // TRIGGER INTERNAL EVENT
            add(const events.CameraInferenceEvent.setInitialConfig());
            add(const events.CameraInferenceEvent.startSystemMonitor());
          },
          error: (message) {
            emit(
              state.copyWith(status: CameraInferenceStatus.failure(message)),
            );
          },
        );
      },
      onError: (error, stackTrace) {
        emit(
          state.copyWith(
            status: CameraInferenceStatus.failure(error.toString()),
          ),
        );
      },
    );
  }

  void _onSetInitialConfig(
    events.SetInitialConfig event,
    Emitter<CameraInferenceState> emit,
  ) {
    _setThresholds(
      confidenceThreshold: state.confidenceThreshold,
      iouThreshold: state.iouThreshold,
      numItemsThreshold: state.numItemsThreshold,
    );

    _yoloController.setZoomLevel(state.currentZoomLevel);
  }

  void _onFlipCamera(
    events.FlipCamera event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloController.switchCamera();

    emit(
      state.copyWith(
        currentLensFacing: state.currentLensFacing == LensFacing.front
            ? LensFacing.back
            : LensFacing.front,
        currentZoomLevel: 1.0,
      ),
    );
  }

  void _onSetZoomLevel(
    events.SetZoomLevel event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloController.setZoomLevel(event.zoomLevel);
    emit(state.copyWith(currentZoomLevel: event.zoomLevel));
  }

  void _onUpdateConfidenceThreshold(
    events.UpdateConfidenceThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _setConfidenceThreshold(event.threshold);
    emit(state.copyWith(confidenceThreshold: event.threshold));
  }

  void _onUpdateIouThreshold(
    events.UpdateIouThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _setIoUThreshold(event.threshold);
    emit(state.copyWith(iouThreshold: event.threshold));
  }

  void _onUpdateNumItemsThreshold(
    events.UpdateNumItemsThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _setNumItemsThreshold(event.threshold);
    emit(state.copyWith(numItemsThreshold: event.threshold));
  }

  void _onDetectionsOccurred(
    events.DetectionsOccurred event,
    Emitter<CameraInferenceState> emit,
  ) {
    _frameCount++;
    final nowTime = DateTime.now();
    final elapsed = nowTime.difference(_lastFpsUpdate).inMilliseconds;

    if (elapsed >= 1000) {
      _currentFps = (_frameCount / elapsed) * 1000;
      _frameCount = 0;
      _lastFpsUpdate = nowTime;
    }

    if (_detectionCount != event.detections.length) {
      _detectionCount = event.detections.length;
      emit(
        state.copyWith(currentFps: _currentFps, detections: event.detections),
      );
    }
  }

  void _onToggleSlider(
    events.ToggleSlider event,
    Emitter<CameraInferenceState> emit,
  ) {
    if (state.activeSlider == event.type) {
      emit(state.copyWith(activeSlider: InferenceParameter.none));
    } else {
      emit(state.copyWith(activeSlider: event.type));
    }
  }
}
