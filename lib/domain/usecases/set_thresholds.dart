import 'package:injectable/injectable.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetThresholds {
  final YoloRepository _repository;

  SetThresholds({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call({
    required double confidenceThreshold,
    required double iouThreshold,
    required int numItemsThreshold,
  }) {
    _repository.setThresholds(
      confidenceThreshold: confidenceThreshold,
      iouThreshold: iouThreshold,
      numItemsThreshold: numItemsThreshold,
    );
  }
}
