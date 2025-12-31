import 'package:system_monitor_example/domain/entities/system_metrics.dart';

abstract class SystemMonitorRepository {
  Stream<SystemMetrics> get metricsStream;
  void start();
  void stop();
  void dispose();
}
