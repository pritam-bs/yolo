import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetConfidenceThreshold {
  final YoloRepository _repository;

  SetConfidenceThreshold({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call(double threshold) {
    _repository.setConfidenceThreshold(threshold);
  }
}
