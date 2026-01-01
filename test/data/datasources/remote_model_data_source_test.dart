// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:yolo/data/datasources/download_progress.dart';
import 'package:yolo/data/datasources/remote_data_source_exception.dart';
import 'package:yolo/data/datasources/remote_model_data_source.dart';
import 'package:yolo/domain/entities/models.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockClient mockClient;
  late MockPlatform mockPlatform;
  late RemoteModelDataSource dataSource;

  setUp(() {
    mockClient = MockClient();
    mockPlatform = MockPlatform();
    dataSource = RemoteModelDataSource(mockClient, mockPlatform);
  });

  group('RemoteModelDataSource', () {
    const modelType = ModelType.detect;

    // Helper to create a mock streaming response
    http.StreamedResponse createMockStreamedResponse(
      List<Uint8List> chunks,
      int statusCode, {
      int? contentLength,
    }) {
      return http.StreamedResponse(
        Stream.fromIterable(chunks),
        statusCode,
        contentLength: contentLength,
      );
    }

    test(
      'downloadModel emits correct progress and completes with data on success',
      () async {
        // Arrange
        when(mockPlatform.isIOS).thenReturn(true);
        final chunks = [
          Uint8List.fromList([1, 2]),
          Uint8List.fromList([3, 4]),
          Uint8List.fromList([5, 6]),
          Uint8List.fromList([7, 8]),
        ];
        final totalLength = chunks.fold<int>(
          0,
          (sum, list) => sum + list.length,
        );
        final response = createMockStreamedResponse(
          chunks,
          200,
          contentLength: totalLength,
        );

        when(mockClient.send(any)).thenAnswer((_) async => response);

        // Act
        final stream = dataSource.downloadModel(modelType);

        // Assert
        final expectedData = BytesBuilder();
        for (final chunk in chunks) {
          expectedData.add(chunk);
        }

        expect(
          stream,
          emitsInOrder([
            const DownloadProgress(progress: 0.0),
            DownloadProgress(progress: 2 / totalLength),
            DownloadProgress(progress: 4 / totalLength),
            DownloadProgress(progress: 6 / totalLength),
            DownloadProgress(progress: 8 / totalLength),
            DownloadProgress(
              progress: 1.0,
              isCompleted: true,
              data: expectedData.toBytes(),
            ),
            emitsDone,
          ]),
        );
      },
    );

    test(
      'downloadModel completes without progress when contentLength is null',
      () async {
        // Arrange
        when(mockPlatform.isIOS).thenReturn(false);
        final chunks = [
          Uint8List.fromList([1, 2, 3, 4]),
          Uint8List.fromList([5, 6, 7, 8]),
        ];
        final response = createMockStreamedResponse(chunks, 200);
        when(mockClient.send(any)).thenAnswer((_) async => response);

        // Act
        final stream = dataSource.downloadModel(modelType);

        // Assert
        final expectedData = BytesBuilder();
        for (final chunk in chunks) {
          expectedData.add(chunk);
        }
        expect(
          stream,
          emitsInOrder([
            const DownloadProgress(progress: 0.0),
            DownloadProgress(
              progress: 1.0,
              isCompleted: true,
              data: expectedData.toBytes(),
            ),
            emitsDone,
          ]),
        );
      },
    );

    test('downloadModel emits error when server returns 404', () async {
      // Arrange
      when(mockPlatform.isIOS).thenReturn(false);
      final response = createMockStreamedResponse([], 404);
      when(mockClient.send(any)).thenAnswer((_) async => response);

      // Act
      final stream = dataSource.downloadModel(modelType);

      // Assert
      expect(
        stream,
        emitsInOrder([
          const DownloadProgress(progress: 0.0),
          isA<DownloadProgress>()
              .having(
                (p) => (p.error as RemoteDataSourceException).statusCode,
                'error.statusCode',
                404,
              )
              .having((p) => p.isCompleted, 'isCompleted', false),
          emitsDone,
        ]),
      );
    });

    test('downloadModel emits error on SocketException', () async {
      // Arrange
      when(mockPlatform.isIOS).thenReturn(false);
      when(
        mockClient.send(any),
      ).thenThrow(const SocketException('No internet'));

      // Act
      final stream = dataSource.downloadModel(modelType);

      // Assert
      expect(
        stream,
        emitsInOrder([
          const DownloadProgress(progress: 0.0),
          isA<DownloadProgress>().having(
            (p) => (p.error as RemoteDataSourceException).message,
            'error.message',
            'No internet connection detected.',
          ),
          emitsDone,
        ]),
      );
    });

    test('downloadModel emits error on timeout', () async {
      // Arrange
      when(mockPlatform.isIOS).thenReturn(false);
      when(mockClient.send(any)).thenAnswer(
        (_) async => Future.delayed(
          const Duration(seconds: 16),
          () => createMockStreamedResponse([], 200),
        ),
      );

      // Act
      final stream = dataSource.downloadModel(modelType);

      // Assert
      expect(
        stream,
        emitsInOrder([
          const DownloadProgress(progress: 0.0),
          isA<DownloadProgress>().having(
            (p) => (p.error as RemoteDataSourceException).message,
            'error.message',
            startsWith('An unexpected error occurred:'),
          ),
          emitsDone,
        ]),
      );
    });

    test('downloadModel requests correct URL for iOS platform', () async {
      // Arrange
      when(mockPlatform.isIOS).thenReturn(true); // Key change for this test
      final response = createMockStreamedResponse([], 200);
      when(mockClient.send(any)).thenAnswer((_) async => response);
      final expectedUrl = Uri.parse(
        'https://github.com/ultralytics/yolo-flutter-app/releases/download/v0.0.0/yolo11n.mlpackage.zip',
      );

      // Act
      // We don't need to check the stream output here, just the URL
      await dataSource.downloadModel(modelType).last;

      // Assert
      final verification = verify(mockClient.send(captureAny));
      verification.called(1);
      final capturedRequest = verification.captured.first as http.Request;
      expect(capturedRequest.url, expectedUrl);
    });
  });
}
