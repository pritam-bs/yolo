import 'package:injectable/injectable.dart';

import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetNumItemsThreshold {
  final YoloRepository _repository;

  SetNumItemsThreshold({required YoloRepository yoloRepository})
    : _repository = yoloRepository;

  void call(int threshold) {
    _repository.setNumItemsThreshold(threshold);
  }
}
