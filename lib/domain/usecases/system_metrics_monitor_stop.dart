import 'package:injectable/injectable.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@lazySingleton
class SystemMetricsMonitorStop {
  final SystemMonitorRepository repository;

  SystemMetricsMonitorStop(this.repository);

  void call() {
    return repository.stop();
  }
}
