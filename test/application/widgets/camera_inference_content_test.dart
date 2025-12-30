import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo/yolo_streaming_config.dart';
import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_state.dart';
import 'package:yolo/application/widgets/camera_inference_content.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:rxdart/rxdart.dart';

import 'camera_inference_content_test.mocks.dart';

@GenerateMocks([YOLOViewController])
void main() {
  group('CameraInferenceContent', () {
    late MockCameraInferenceBloc mockCameraInferenceBloc;
    late MockYOLOViewController mockYOLOViewController;
    late BehaviorSubject<CameraInferenceState> cameraInferenceStateSubject;

    setUp(() {
      mockCameraInferenceBloc = MockCameraInferenceBloc();
      mockYOLOViewController = MockYOLOViewController();
      cameraInferenceStateSubject = BehaviorSubject<CameraInferenceState>();

      // Default stub for the bloc's state
      when(mockCameraInferenceBloc.state).thenReturn(
        const CameraInferenceState(
          modelPath: 'test_path',
          modelType: ModelType.detect,
          currentLensFacing: LensFacing.back,
          systemHealthState: SystemHealthState.normal,
        ),
      );
      // Stub the stream to return our BehaviorSubject
      when(
        mockCameraInferenceBloc.stream,
      ).thenAnswer((_) => cameraInferenceStateSubject.stream);
      // Initialize the subject with the default state
      cameraInferenceStateSubject.add(mockCameraInferenceBloc.state);

      when(
        mockYOLOViewController.setStreamingConfig(any),
      ).thenAnswer((_) async {});
      when(
        mockYOLOViewController.setThresholds(
          confidenceThreshold: anyNamed('confidenceThreshold'),
          iouThreshold: anyNamed('iouThreshold'),
          numItemsThreshold: anyNamed('numItemsThreshold'),
        ),
      ).thenAnswer((_) async {});
      when(mockYOLOViewController.numItemsThreshold).thenReturn(30);
      when(mockYOLOViewController.confidenceThreshold).thenReturn(0.5);
      when(mockYOLOViewController.iouThreshold).thenReturn(0.45);
    });

    tearDown(() {
      cameraInferenceStateSubject.close();
    });

    Widget buildWidget({
      String? modelPath = 'test_path',
      ModelType modelType = ModelType.detect,
      LensFacing currentLensFacing = LensFacing.back,
      double confidenceThreshold = 0.5,
      double iouThreshold = 0.45,
      SystemHealthState systemHealthState = SystemHealthState.normal,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<CameraInferenceBloc>.value(
            value: mockCameraInferenceBloc,
            child: CameraInferenceContent(
              modelPath: modelPath,
              modelType: modelType,
              onResult: (_) {},
              yoloViewController: mockYOLOViewController,
              currentLensFacing: currentLensFacing,
              confidenceThreshold: confidenceThreshold,
              iouThreshold: iouThreshold,
            ),
          ),
        ),
      );
    }

    testWidgets('renders YOLOView when modelPath is not null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byType(YOLOView), findsOneWidget);
    });

    testWidgets(
      'calls setStreamingConfig and setThresholds for normal state on initial render',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildWidget(systemHealthState: SystemHealthState.normal),
        );
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.highPerformance(),
          ),
        ).called(1);
        verify(
          mockYOLOViewController.setThresholds(
            confidenceThreshold: 0.5,
            iouThreshold: 0.45,
            numItemsThreshold: 30,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'calls setStreamingConfig and setThresholds for warning state when systemHealthState changes to warning',
      (WidgetTester tester) async {
        // Arrange
        cameraInferenceStateSubject.add(
          const CameraInferenceState(
            modelPath: 'test_path',
            modelType: ModelType.detect,
            currentLensFacing: LensFacing.back,
            systemHealthState: SystemHealthState.warning,
          ),
        );

        await tester.pumpWidget(buildWidget());
        await tester
            .pumpAndSettle(); // Allow BlocConsumer to react to state changes

        // Assert that warning state config is applied
        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.powerSaving(),
          ),
        ).called(1);
        verify(
          mockYOLOViewController.setThresholds(
            confidenceThreshold: 0.4,
            iouThreshold: 0.5,
            numItemsThreshold: 20,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'calls setStreamingConfig and setThresholds for critical state when systemHealthState changes to critical',
      (WidgetTester tester) async {
        // Arrange
        cameraInferenceStateSubject.add(
          const CameraInferenceState(
            modelPath: 'test_path',
            modelType: ModelType.detect,
            currentLensFacing: LensFacing.back,
            systemHealthState: SystemHealthState.critical,
          ),
        );

        await tester.pumpWidget(buildWidget());
        await tester
            .pumpAndSettle(); // Allow BlocConsumer to react to state changes

        // Assert that critical state config is applied
        verify(
          mockYOLOViewController.setStreamingConfig(
            const YOLOStreamingConfig.powerSaving(),
          ),
        ).called(1);
        verify(
          mockYOLOViewController.setThresholds(
            confidenceThreshold: 0.3,
            iouThreshold: 0.6,
            numItemsThreshold: 10,
          ),
        ).called(1);
      },
    );
  });
}
