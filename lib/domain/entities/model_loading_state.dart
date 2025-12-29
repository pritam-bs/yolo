import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_loading_state.freezed.dart';

@freezed
abstract class ModelLoadingState with _$ModelLoadingState {
  const factory ModelLoadingState.initial() = _Initial;
  const factory ModelLoadingState.loading(double progress) = _Loading;
  const factory ModelLoadingState.ready(String modelPath) = _Ready;
  const factory ModelLoadingState.error(String message) = _Error;
}
