import 'package:injectable/injectable.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@lazySingleton
class SystemMetricsMonitorStart {
  final SystemMonitorRepository repository;

  SystemMetricsMonitorStart(this.repository);

  void call({Duration interval = const Duration(minutes: 5)}) {
    return repository.start(interval: interval);
  }
}
