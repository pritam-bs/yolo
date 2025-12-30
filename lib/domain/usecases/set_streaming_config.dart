import 'package:injectable/injectable.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';

@injectable
class SetStreamingConfig {
  final YoloRepository _yoloRepository;

  SetStreamingConfig(this._yoloRepository);

  Future<void> call(SystemHealthState health) async {
    _yoloRepository.setStreamingConfig(health);
  }
}
