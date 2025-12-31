// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:yolo/application/screens/camera_inference_screen.dart';
import 'package:yolo/injection.dart';
import 'package:yolo/main.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('Renders CameraInferenceScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that CameraInferenceScreen is rendered.
    expect(find.byType(CameraInferenceScreen), findsOneWidget);
  });
}
