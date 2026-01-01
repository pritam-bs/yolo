import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;
import 'package:yolo/data/repositories/system_monitor_repository_impl.dart';
import 'package:yolo/domain/entities/system_metrics.dart';
import '../../mocks.mocks.dart' show MockSystemMonitor;

void main() {
  late SystemMonitorRepositoryImpl repository;
  late MockSystemMonitor mockSystemMonitor;

  setUp(() {
    mockSystemMonitor = MockSystemMonitor();
    repository = SystemMonitorRepositoryImpl(mockSystemMonitor);
  });

  group('SystemMonitorRepositoryImpl', () {
    // A. The "Translation" (Mapping) Logic
    test(
      'WHEN plugin emits a metrics object with a specific thermalState, THEN the repository stream emits the corresponding Domain-specific enum',
      () async {
        when(mockSystemMonitor.metricsStream).thenAnswer(
          (_) => Stream.fromIterable([
            plugin.SystemMetrics(
              batteryLevel: 50,
              ramUsage: 0.6,
              thermalState: plugin.ThermalState.nominal,
            ),
            plugin.SystemMetrics(
              batteryLevel: 40,
              ramUsage: 0.7,
              thermalState: plugin.ThermalState.critical,
            ),
          ]),
        );

        final stream = repository.metricsStream;

        expect(
          stream,
          emitsInOrder([
            const SystemMetrics(
              batteryLevel: 50,
              ramUsage: 0.6,
              thermalState: ThermalState.nominal,
            ),
            const SystemMetrics(
              batteryLevel: 40,
              ramUsage: 0.7,
              thermalState: ThermalState.critical,
            ),
            emitsDone,
          ]),
        );
      },
    );

    // B. Error Handling & Fallback
    test(
      'WHEN plugin returns a state that does not exist in domain enum, THEN repository emits ThermalState.unknown',
      () async {
        when(mockSystemMonitor.metricsStream).thenAnswer(
          (_) => Stream.fromIterable([
            plugin.SystemMetrics(
              batteryLevel: 70,
              ramUsage: 0.3,
              thermalState: plugin.ThermalState.values.firstWhere(
                (element) => element.name == 'nonExistentState',
                orElse: () => plugin.ThermalState.unknown,
              ),
            ),
          ]),
        );

        final stream = repository.metricsStream;

        expect(
          stream,
          emitsInOrder([
            const SystemMetrics(
              batteryLevel: 70,
              ramUsage: 0.3,
              thermalState: ThermalState.unknown,
            ),
            emitsDone,
          ]),
        );
      },
    );

    // C. Resource Lifecycle Management
    test(
      'WHEN repository.dispose() is called, THEN internal _systemMonitor.dispose() is invoked',
      () async {
        when(mockSystemMonitor.dispose()).thenAnswer((_) async => {});

        await repository.dispose();

        verify(mockSystemMonitor.dispose()).called(1);
      },
    );

    test(
      'WHEN repository.stop() is called, THEN internal _systemMonitor.stop() is invoked',
      () async {
        when(mockSystemMonitor.stop()).thenAnswer((_) async => {});

        await repository.stop();

        verify(mockSystemMonitor.stop()).called(1);
      },
    );

    test(
      'WHEN repository.start() is called, THEN internal _systemMonitor.start() is invoked',
      () async {
        when(
          mockSystemMonitor.start(
            interval: argThat(anything, named: 'interval'),
          ),
        ).thenAnswer((_) {});

        const interval = Duration(minutes: 1);
        repository.start(interval: interval);

        verify(
          mockSystemMonitor.start(
            interval: argThat(anything, named: 'interval'),
          ),
        ).called(1);
      },
    );
  });
}
