import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart'; // This is where EventChannel comes from
import 'package:system_monitor/system_monitor.dart';

// Extend MockStreamHandler from flutter_test to create a concrete implementation
class CustomMockStreamHandler extends MockStreamHandler {
  final List<Map<String, dynamic>> log; // To store events
  dynamic _events;

  CustomMockStreamHandler(this.log);

  @override
  Future<void> onListen(dynamic arguments, dynamic events) async {
    // Changed EventSink to dynamic
    _events = events;
    log.add({'method': 'listen', 'arguments': arguments});
    // You can send events here if your test needs to simulate native events
    // events.add({'batteryLevel': 50, 'ramUsage': 60.0, 'thermalState': 'nominal'});
  }

  @override
  Future<void> onCancel(dynamic arguments) async {
    log.add({'method': 'cancel', 'arguments': arguments});
  }

  void sendError(PlatformException error) {
    _events.error(
      code: error.code,
      message: error.message,
      details: error.details,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SystemMonitor', () {
    const EventChannel eventChannel = EventChannel('system_monitor/metrics');
    late SystemMonitor systemMonitor;
    late List<Map<String, dynamic>> log;
    late CustomMockStreamHandler
    mockStreamHandler; // Use my custom concrete mock

    setUp(() {
      systemMonitor = SystemMonitor();
      log = <Map<String, dynamic>>[];
      mockStreamHandler = CustomMockStreamHandler(
        log,
      ); // Instantiate my concrete mock

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(eventChannel, mockStreamHandler);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
            eventChannel,
            null, // Clear the mock handler
          );
      systemMonitor.dispose();
    });

    test('metricsStream is not null on initialization', () {
      expect(systemMonitor.metricsStream, isNotNull);
    });

    test('start() sends correct interval to native side via listen', () async {
      systemMonitor.start(interval: const Duration(seconds: 5));
      await Future<void>.delayed(Duration.zero); // Allow stream to set up

      expect(log, isNotEmpty);
      expect(log.first['method'], 'listen');
      expect(log.first['arguments'], isA<Map>());
      expect((log.first['arguments'] as Map)['interval'], 5000);
    });

    test('stop() cancels the internal subscription', () async {
      systemMonitor.start();
      await Future<void>.delayed(Duration.zero); // Allow stream to set up
      expect(systemMonitor.metricsStream, isNotNull);

      systemMonitor.stop();

      // Verify that 'cancel' was sent to native
      expect(
        log,
        contains(
          predicate((e) => (e as Map<String, dynamic>)['method'] == 'cancel'),
        ),
      );
    });

    test('SystemMetrics.fromMap creates correct object', () {
      final Map<String, dynamic> testMap = {
        'batteryLevel': 75,
        'ramUsage': 40.2,
        'thermalState': 'nominal',
      };
      final metrics = SystemMetrics.fromMap(testMap);

      expect(metrics.batteryLevel, 75);
      expect(metrics.ramUsage, 40.2);
      expect(metrics.thermalState, ThermalState.nominal);
      expect(
        metrics.toString(),
        'SystemMetrics(battery: 75%, ram: 40.2%, thermal: nominal)',
      );
    });

    test('SystemMetrics handles null/missing values fromMap gracefully', () {
      final Map<String, dynamic> testMap = {};
      final metrics = SystemMetrics.fromMap(testMap);

      expect(metrics.batteryLevel, -1);
      expect(metrics.ramUsage, 0.0);
      expect(metrics.thermalState, ThermalState.unknown);
    });

    test('start() ignores subsequent calls if already active', () {
      systemMonitor.start();
      final Stream<SystemMetrics> initialStream = systemMonitor.metricsStream;

      systemMonitor.start(interval: const Duration(seconds: 1)); // Call again
      expect(
        systemMonitor.metricsStream,
        same(initialStream),
      ); // Should be the same instance

      expect(log.where((e) => (e)['method'] == 'listen').length, 1);
    });

    test('stream emits error when native side sends an error', () async {
      systemMonitor.start();
      await Future<void>.delayed(Duration.zero);

      final error = PlatformException(
        code: 'TEST_ERROR',
        message: 'This is a test error',
      );

      expect(
        systemMonitor.metricsStream,
        emitsError(
          isA<PlatformException>().having((e) => e.code, 'code', 'TEST_ERROR'),
        ),
      );

      mockStreamHandler.sendError(error);
    });
  });
}
