import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/application/screens/camera_inference_screen.dart';

class MockCameraInferenceBloc
    extends MockBloc<CameraInferenceEvent, CameraInferenceState>
    implements CameraInferenceBloc {}

void main() {
  late CameraInferenceBloc mockCameraInferenceBloc;

  setUp(() {
    mockCameraInferenceBloc = MockCameraInferenceBloc();
  });

  testWidgets('Renders CameraInferenceScreen', (WidgetTester tester) async {
    whenListen(
      mockCameraInferenceBloc,
      Stream.fromIterable([
        const CameraInferenceState(
          status: CameraInferenceStatus.initial(),
          detections: [],
        ),
      ]),
      initialState: const CameraInferenceState(
        status: CameraInferenceStatus.initial(),
        detections: [],
      ),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CameraInferenceBloc>.value(
          value: mockCameraInferenceBloc,
          child: const CameraInferenceScreen(),
        ),
      ),
    );

    // Verify that CameraInferenceScreen is rendered.
    expect(find.byType(CameraInferenceScreen), findsOneWidget);
  });
}
