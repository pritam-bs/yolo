import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:system_monitor/system_monitor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('metricsStream test', (WidgetTester tester) async {
    final SystemMonitor plugin = SystemMonitor();
    plugin.start(interval: const Duration(seconds: 1));

    final metrics = await plugin.metricsStream.first;

    // Check that the metrics are not null and have valid values
    expect(metrics, isNotNull);
    expect(metrics.batteryLevel, isA<int>());
    expect(metrics.ramUsage, isA<double>());
    expect(metrics.thermalState, isA<ThermalState>());

    plugin.dispose();
  });
}
