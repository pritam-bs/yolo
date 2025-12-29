import 'package:yolo/domain/repositories/yolo_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class FlipCamera {
  final YoloRepository repository;

  FlipCamera(this.repository);

  void call() {
    repository.flipCamera();
  }
}
