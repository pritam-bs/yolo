import 'package:yolo/domain/entities/model_loading_state.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetModelPath {
  final YoloRepository _repository;

  GetModelPath({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  Stream<ModelLoadingState> call(ModelType modelType) {
    return _repository.getModelPath(modelType);
  }
}
