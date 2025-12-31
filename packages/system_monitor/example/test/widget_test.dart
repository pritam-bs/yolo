// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:system_monitor_example/app/injection.dart'; // Import for configureDependencies()
import 'package:system_monitor_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Initialize GetIt dependencies before pumping the widget.
    TestWidgetsFlutterBinding.ensureInitialized();
    configureDependencies();
    await tester.pumpWidget(const MyApp());

    // Verify that platform version is retrieved.
    expect(find.text('System Monitor Example'), findsOneWidget);
  });
}
