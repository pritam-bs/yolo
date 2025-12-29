import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetConfidenceThreshold {
  final YoloRepository repository;

  SetConfidenceThreshold(this.repository);

  void call(double threshold) {
    repository.setConfidenceThreshold(threshold);
  }
}
