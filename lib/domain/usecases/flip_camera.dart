import 'package:yolo/domain/repositories/yolo_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class FlipCamera {
  final YoloRepository _repository;

  FlipCamera({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call() {
    _repository.flipCamera();
  }
}
