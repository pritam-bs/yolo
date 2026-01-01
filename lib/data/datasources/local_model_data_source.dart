import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file/file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:yolo/domain/entities/models.dart';
import 'package:injectable/injectable.dart';

abstract class LocalModelDataSource {
  Future<String?> getModelPath(ModelType modelType);
  Future<String> saveModel(ModelType modelType, Uint8List bytes, bool isZip);
}

@Injectable(as: LocalModelDataSource)
class LocalModelDataSourceImpl implements LocalModelDataSource {
  final FileSystem _fileSystem;
  final Platform _platform;

  LocalModelDataSourceImpl(this._fileSystem, this._platform);

  @override
  Future<String?> getModelPath(ModelType modelType) async {
    final dir = await getApplicationDocumentsDirectory();
    final String modelPath;

    if (_platform.isIOS) {
      modelPath = _getIOSModelDirPath(modelType, dir.path);
    } else if (_platform.isAndroid) {
      modelPath = _getAndroidModelFilePath(modelType, dir.path);
    } else {
      // This will crash the app with a clear message if run on Web, Windows, Mac, or Linux
      throw UnsupportedError(
        'The ultralytics_yolo package only supports iOS and Android. '
        'Current platform: ${_platform.operatingSystem}',
      );
    }

    if (_platform.isIOS) {
      final modelDir = _fileSystem.directory(modelPath);
      if (await modelDir.exists()) {
        // For iOS, check if Manifest.json exists within the .mlpackage directory
        if (await _fileSystem.file('${modelDir.path}/Manifest.json').exists()) {
          return modelDir.path;
        } else {
          // If directory exists but Manifest.json is missing, delete and return null
          await modelDir.delete(recursive: true);
          return null;
        }
      }
    } else {
      final modelFile = _fileSystem.file(modelPath);
      if (await modelFile.exists()) {
        return modelFile.path;
      }
    }
    return null;
  }

  @override
  Future<String> saveModel(
    ModelType modelType,
    Uint8List bytes,
    bool isZip,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final String targetPath;

    if (_platform.isIOS) {
      final modelDirPath = _getIOSModelDirPath(modelType, dir.path);
      final modelDir = _fileSystem.directory(modelDirPath);

      if (await modelDir.exists()) {
        await modelDir.delete(
          recursive: true,
        ); // Clean up any old partial downloads
      }

      if (isZip) {
        return await _extractZip(bytes, modelDir, modelType.modelName);
      } else {
        // Should not happen for iOS mlpackage, but as a fallback
        throw Exception('iOS models (.mlpackage) should be provided as a zip.');
      }
    } else if (_platform.isAndroid) {
      // Android .tflite model
      targetPath = _getAndroidModelFilePath(modelType, dir.path);
      final modelFile = _fileSystem.file(targetPath);

      if (await modelFile.exists()) {
        await modelFile.delete(); // Clean up any old partial downloads
      }

      await modelFile.parent.create(recursive: true);
      await modelFile.writeAsBytes(bytes);
      return modelFile.path;
    } else {
      // This will crash the app with a clear message if run on Web, Windows, Mac, or Linux
      throw UnsupportedError(
        'The ultralytics_yolo package only supports iOS and Android. '
        'Current platform: ${_platform.operatingSystem}',
      );
    }
  }

  String _getIOSModelDirPath(ModelType modelType, String baseDir) {
    return '$baseDir/${modelType.modelName}.mlpackage';
  }

  String _getAndroidModelFilePath(ModelType modelType, String baseDir) {
    return '$baseDir/${modelType.modelName}.tflite';
  }

  // Helper method to extract zip file, adapted from ModelManager
  Future<String> _extractZip(
    List<int> bytes,
    Directory targetDir,
    String modelName,
  ) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      await targetDir.create(recursive: true);
      String? prefix;
      if (archive.files.isNotEmpty) {
        final first = archive.files.first.name;
        if (first.contains('/') &&
            first.split('/').first.endsWith('.mlpackage')) {
          final topDir = first.split('/').first;
          if (archive.files.every(
            (f) => f.name.startsWith('$topDir/') || f.name == topDir,
          )) {
            prefix = '$topDir/';
          }
        }
      }
      for (final file in archive) {
        var filename = file.name;
        if (prefix != null) {
          if (filename.startsWith(prefix)) {
            filename = filename.substring(prefix.length);
          } else if (filename == prefix.replaceAll('/', '')) {
            continue;
          }
        }
        if (filename.isEmpty) continue;
        if (file.isFile) {
          final outputFile = _fileSystem.file('${targetDir.path}/$filename');
          await outputFile.parent.create(recursive: true);
          await outputFile.writeAsBytes(file.content as List<int>);
        }
      }
      return targetDir.path;
    } catch (e) {
      if (await targetDir.exists()) {
        await targetDir.delete(recursive: true);
      }
      throw Exception('Failed to extract model zip: $e');
    }
  }
}
