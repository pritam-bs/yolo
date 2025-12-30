import 'package:yolo/domain/entities/system_metrics.dart';

abstract class SystemMonitorRepository {
  Stream<SystemMetrics> get metricsStream;
  void start({Duration interval = const Duration(minutes: 5)});
  void stop();
  void dispose();
}
