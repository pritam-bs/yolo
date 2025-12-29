import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetIoUThreshold {
  final YoloRepository repository;

  SetIoUThreshold(this.repository);

  void call(double threshold) {
    repository.setIoUThreshold(threshold);
  }
}
