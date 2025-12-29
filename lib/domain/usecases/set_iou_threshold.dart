import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetIoUThreshold {
  final YoloRepository _repository;

  SetIoUThreshold({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call(double threshold) {
    _repository.setIoUThreshold(threshold);
  }
}
