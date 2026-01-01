import 'dart:typed_data';

import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:platform/platform.dart';
import 'package:yolo/data/datasources/local_model_data_source.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:archive/archive.dart';

import 'mock_path_provider_platform.dart';


void main() {
  late MemoryFileSystem fileSystem;
  late MockPathProviderPlatform mockPathProvider;
  late LocalModelDataSourceImpl dataSource;

  const String mockDocsDir = '/data/user/0/com.yolo.app/app_flutter';

  setUp(() {
    fileSystem = MemoryFileSystem();
    mockPathProvider = MockPathProviderPlatform();

    // Set the singleton instance to our mock
    PathProviderPlatform.instance = mockPathProvider;

    // Stub the path provider to return our fake directory
    when(
      mockPathProvider.getApplicationDocumentsPath(),
    ).thenAnswer((_) async => mockDocsDir);
  });

  /// Helper to create valid zip bytes for testing iOS .mlpackage extraction logic.
  Uint8List createMlPackageZip({
    required String modelName,
    bool includeManifest = true,
  }) {
    final archive = Archive();
    final dirName = '$modelName.mlpackage';

    // Add dummy file content to simulate the package structure
    archive.addFile(ArchiveFile('$dirName/Data/weights.bin', 4, [0, 1, 2, 3]));

    if (includeManifest) {
      // Manifest.json is critical for validation in LocalModelDataSourceImpl
      archive.addFile(
        ArchiveFile('$dirName/Manifest.json', 2, [123, 125]), // Represents "{}"
      );
    }

    return Uint8List.fromList(ZipEncoder().encode(archive)!);
  }

  group('LocalModelDataSourceImpl Tests', () {
    group('iOS Platform (mlpackage handling)', () {
      setUp(() {
        dataSource = LocalModelDataSourceImpl(fileSystem, FakePlatform(operatingSystem:"ios"));
      });

      test(
        'saveModel should unzip content into .mlpackage directory',
        () async {
          final modelType = ModelType.detect;
          final zipBytes = createMlPackageZip(modelName: modelType.modelName);

          final result = await dataSource.saveModel(modelType, zipBytes, true);

          final expectedPath = '$mockDocsDir/${modelType.modelName}.mlpackage';
          expect(result, expectedPath);
          expect(fileSystem.directory(expectedPath).existsSync(), isTrue);
          expect(
            fileSystem.file('$expectedPath/Manifest.json').existsSync(),
            isTrue,
          );
        },
      );

      test(
        'getModelPath should return null and delete directory if Manifest.json is missing',
        () async {
          final modelType = ModelType.detect;
          final expectedPath = '$mockDocsDir/${modelType.modelName}.mlpackage';

          // Save a "corrupted" zip (no manifest)
          final zipBytes = createMlPackageZip(
            modelName: modelType.modelName,
            includeManifest: false,
          );
          await dataSource.saveModel(modelType, zipBytes, true);

          // Act: verify data source detects corruption
          final result = await dataSource.getModelPath(modelType);

          // Assert: result is null and corrupted dir is wiped
          expect(result, isNull);
          expect(fileSystem.directory(expectedPath).existsSync(), isFalse);
        },
      );

      test(
        'saveModel should throw Exception if isZip is false on iOS',
        () async {
          final modelType = ModelType.detect;
          expect(
            () => dataSource.saveModel(modelType, Uint8List(0), false),
            throwsException,
          );
        },
      );
    });

    group('Android Platform (tflite handling)', () {
      setUp(() {
        dataSource = LocalModelDataSourceImpl(fileSystem, FakePlatform(operatingSystem: "android"),
        );
      });

      test('saveModel should write raw bytes to .tflite file', () async {
        final modelType = ModelType.detect;
        final rawBytes = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

        final result = await dataSource.saveModel(modelType, rawBytes, false);

        final expectedPath = '$mockDocsDir/${modelType.modelName}.tflite';
        expect(result, expectedPath);
        expect(fileSystem.file(expectedPath).existsSync(), isTrue);
        expect(fileSystem.file(expectedPath).readAsBytesSync(), rawBytes);
      });

      test('getModelPath should return path if .tflite file exists', () async {
        final modelType = ModelType.detect;
        final expectedPath = '$mockDocsDir/${modelType.modelName}.tflite';
        fileSystem.file(expectedPath).createSync(recursive: true);

        final result = await dataSource.getModelPath(modelType);

        expect(result, expectedPath);
      });
    });

    group('Unsupported Platforms', () {
      test('should throw UnsupportedError on Windows/Desktop', () async {
        dataSource = LocalModelDataSourceImpl(fileSystem, FakePlatform(operatingSystem: "windows"),
        );

        expect(
          () => dataSource.getModelPath(ModelType.detect),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
  });
}
