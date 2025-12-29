import 'package:injectable/injectable.dart';

import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetLensFacing {
  final YoloRepository repository;

  SetLensFacing(this.repository);

  void call(LensFacing facing) {
    repository.setLensFacing(facing);
  }
}
