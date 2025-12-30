import 'package:injectable/injectable.dart';
import 'package:yolo/domain/entities/system_metrics.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@lazySingleton
class GetSystemMetrics {
  final SystemMonitorRepository repository;

  GetSystemMetrics(this.repository);

  Stream<SystemMetrics> call() {
    return repository.metricsStream;
  }
}
