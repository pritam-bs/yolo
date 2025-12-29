import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:ultralytics_yolo/yolo_view.dart'; // For LensFacing
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/model_loading_state.dart'; // New import
import 'camera_inference_event.dart' as events;
import 'camera_inference_state.dart';

@injectable
class CameraInferenceBloc
    extends Bloc<events.CameraInferenceEvent, CameraInferenceState> {
  final YoloRepository _yoloRepository;
  late final YOLOViewController _yoloViewController;

  CameraInferenceBloc({required YoloRepository yoloRepository})
    : _yoloRepository = yoloRepository,
      super(const CameraInferenceState()) {
    _yoloViewController = _yoloRepository.yoloViewController;
    on<events.InitializeCamera>(_onInitializeCamera);
    on<events.ChangeModel>(_onChangeModel);
    on<events.FlipCamera>(_onFlipCamera);
    on<events.SetZoomLevel>(_onSetZoomLevel);
    on<events.UpdateConfidenceThreshold>(_onUpdateConfidenceThreshold);
    on<events.UpdateIouThreshold>(_onUpdateIouThreshold);
    on<events.UpdateNumItemsThreshold>(_onUpdateNumItemsThreshold);
    on<events.DetectionsOccurred>(_onDetectionsOccurred);
    on<events.ToggleSlider>(_onToggleSlider);
    on<events.UpdateFps>(_onUpdateFps);
    on<events.UpdateLensFacing>(_onUpdateLensFacing);
    on<events.RetryModelDownload>(_onRetryModelDownload);
    on<events.ResumeCamera>(_onResumeLayoutCamera);
  }

  void _onUpdateFps(
    events.UpdateFps event,
    Emitter<CameraInferenceState> emit,
  ) {
    emit(state.copyWith(currentFps: event.fps));
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
    await _downloadModel(event.model, emit);
  }

  Future<void> _onRetryModelDownload(
    events.RetryModelDownload event,
    Emitter<CameraInferenceState> emit,
  ) async {
    emit(state.copyWith(status: const CameraInferenceStatus.loading()));
    await _downloadModel(state.modelType, emit);
  }

  Future<void> _onResumeLayoutCamera(
    events.ResumeCamera event,
    Emitter<CameraInferenceState> emit,
  ) async {
    if (state.status == const CameraInferenceStatus.initial() ||
        state.status.maybeWhen(failure: (_) => true, orElse: () => false)) {
      emit(state.copyWith(status: const CameraInferenceStatus.loading()));
      await _downloadModel(state.modelType, emit);
    }
  }

  Future<void> _downloadModel(
    ModelType modelType,
    Emitter<CameraInferenceState> emit,
  ) async {
    await emit.forEach(
      _yoloRepository.getModelPath(modelType),
      onData: (modelLoadingState) {
        return modelLoadingState.when(
          initial: () => state, // Should not happen after initial loading
          loading: (progress) => state.copyWith(
            status: CameraInferenceStatus.modelLoading(progress),
          ),
          ready: (modelPath) => state.copyWith(
            status: const CameraInferenceStatus.success(),
            modelPath: modelPath,
          ),
          error: (message) => state.copyWith(
            status: CameraInferenceStatus.failure(message),
            errorMessage: message,
          ),
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: CameraInferenceStatus.failure(error.toString()),
        errorMessage: error.toString(),
      ),
    );
  }

  void _onFlipCamera(
    events.FlipCamera event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloViewController.switchCamera();
    emit(
      state.copyWith(
        currentLensFacing: state.currentLensFacing == LensFacing.front
            ? LensFacing.back
            : LensFacing.front,
      ),
    );
  }

  void _onSetZoomLevel(
    events.SetZoomLevel event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloViewController.setZoomLevel(event.zoomLevel);
    emit(state.copyWith(currentZoomLevel: event.zoomLevel));
  }

  void _onUpdateConfidenceThreshold(
    events.UpdateConfidenceThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloViewController.setConfidenceThreshold(event.threshold);
    emit(state.copyWith(confidenceThreshold: event.threshold));
  }

  void _onUpdateIouThreshold(
    events.UpdateIouThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloViewController.setIoUThreshold(event.threshold);
    emit(state.copyWith(iouThreshold: event.threshold));
  }

  void _onUpdateNumItemsThreshold(
    events.UpdateNumItemsThreshold event,
    Emitter<CameraInferenceState> emit,
  ) {
    _yoloViewController.setNumItemsThreshold(event.threshold);
    emit(state.copyWith(numItemsThreshold: event.threshold));
  }

  void _onDetectionsOccurred(
    events.DetectionsOccurred event,
    Emitter<CameraInferenceState> emit,
  ) {
    // FPS calculation logic will be handled here
    emit(state.copyWith(detections: event.detections));
  }

  void _onToggleSlider(
    events.ToggleSlider event,
    Emitter<CameraInferenceState> emit,
  ) {
    if (state.activeSlider == event.type) {
      emit(state.copyWith(activeSlider: SliderType.none));
    } else {
      emit(state.copyWith(activeSlider: event.type));
    }
  }
}
