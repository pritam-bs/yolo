import 'package:injectable/injectable.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;
import 'package:yolo/domain/entities/system_metrics.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';

@LazySingleton(as: SystemMonitorRepository)
class SystemMonitorRepositoryImpl implements SystemMonitorRepository {
  final plugin.SystemMonitor _systemMonitor;

  // For testing
  // Stream<SystemMetrics> get fakeMetricsStream {
  //   return Stream.periodic(const Duration(minutes: 1), (computationCount) {
  //     final random = Random();

  //     // Simulate gradual changes or random spikes
  //     return SystemMetrics(
  //       // Battery drains by 1% every few updates, or remains steady
  //       batteryLevel: max(0, 100 - (computationCount ~/ 5)),

  //       // RAM usage fluctuates between 40% and 95%
  //       ramUsage: 0.4 + (random.nextDouble() * 0.55),

  //       // Randomly pick a thermal state to test different logic branches
  //       thermalState: ThermalState.values[random.nextInt(4)],
  //     );
  //   });
  // }

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

  // @override
  // Stream<SystemMetrics> get metricsStream {
  //   return fakeMetricsStream;
  // }

  @override
  void start({Duration interval = const Duration(minutes: 5)}) {
    _systemMonitor.start(interval: interval);
  }

  @override
  Future<void> stop() async {
    await _systemMonitor.stop();
  }

  @override
  Future<void> dispose() async {
    await _systemMonitor.dispose();
  }
}
