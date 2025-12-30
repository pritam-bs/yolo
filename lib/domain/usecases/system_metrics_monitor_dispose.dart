import 'package:injectable/injectable.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@lazySingleton
class SystemMetricsMonitorDispose {
  final SystemMonitorRepository repository;

  SystemMetricsMonitorDispose(this.repository);

  Future<void> call() async {
    await repository.dispose();
  }
}
