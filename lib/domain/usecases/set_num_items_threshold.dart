import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetNumItemsThreshold {
  final YoloRepository repository;

  SetNumItemsThreshold(this.repository);

  void call(int threshold) {
    repository.setNumItemsThreshold(threshold);
  }
}
