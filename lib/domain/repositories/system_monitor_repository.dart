import 'package:yolo/domain/entities/system_metrics.dart';

abstract class SystemMonitorRepository {
  Stream<SystemMetrics> get metricsStream;
  void start({Duration interval = const Duration(minutes: 5)});
  Future<void> stop();
  Future<void> dispose();
}
