import 'package:injectable/injectable.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;
import 'package:yolo/domain/entities/system_metrics.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@LazySingleton(as: SystemMonitorRepository)
class SystemMonitorRepositoryImpl implements SystemMonitorRepository {
  final plugin.SystemMonitor _systemMonitor;

  SystemMonitorRepositoryImpl(this._systemMonitor);

  @override
  Stream<SystemMetrics> get metricsStream {
    return _systemMonitor.metricsStream.map((metrics) {
      return SystemMetrics(
        batteryLevel: metrics.batteryLevel,
        ramUsage: metrics.ramUsage,
        thermalState: ThermalState.values.firstWhere(
          (element) => element.name == metrics.thermalState.name,
          orElse: () => ThermalState.unknown,
        ),
      );
    });
  }

  @override
  void start({Duration interval = const Duration(minutes: 5)}) {
    _systemMonitor.start(interval: interval);
  }

  @override
  Future<void> stop() async{
    await _systemMonitor.stop();
  }

  @override
  Future<void> dispose() async{
    await _systemMonitor.dispose();
  }
}
