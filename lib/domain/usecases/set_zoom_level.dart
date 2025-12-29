import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';
// For ModelType

@injectable
class SetZoomLevel {
  final YoloRepository _repository;

  SetZoomLevel({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call(double zoomLevel) {
    _repository.setZoomLevel(zoomLevel);
  }
}
