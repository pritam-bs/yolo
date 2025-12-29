import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';
// For ModelType

@injectable
class SetZoomLevel {
  final YoloRepository repository;

  SetZoomLevel(this.repository);

  void call(double zoomLevel) {
    repository.setZoomLevel(zoomLevel);
  }
}
