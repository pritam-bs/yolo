import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:yolo/data/datasources/remote_data_source_exception.dart';
import 'package:yolo/domain/entities/models.dart';

import 'package:injectable/injectable.dart';

import 'download_progress.dart';

@LazySingleton()
class RemoteModelDataSource {
  final http.Client _client;

  RemoteModelDataSource(this._client);

  static const String _modelDownloadBaseUrl =
      'https://github.com/ultralytics/yolo-flutter-app/releases/download/v0.0.0';

  Stream<DownloadProgress> downloadModel(ModelType modelType) async* {
    final String extension = Platform.isIOS ? '.mlpackage.zip' : '.tflite';
    final String url =
        '$_modelDownloadBaseUrl/${modelType.modelName}$extension';

    yield const DownloadProgress(progress: 0.0);

    try {
      final request = http.Request('GET', Uri.parse(url));
      // Adding a timeout for the initial connection
      final response = await _client
          .send(request)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw RemoteDataSourceException(
          'Server returned ${response.statusCode}: Could not find model file.',
          statusCode: response.statusCode,
        );
      }

      final contentLength = response.contentLength ?? 0;
      int downloadedBytes = 0;
      final BytesBuilder bytesBuilder =
          BytesBuilder(); // More efficient for building Uint8List

      await for (final chunk in response.stream) {
        bytesBuilder.add(chunk);
        downloadedBytes += chunk.length;

        if (contentLength > 0) {
          yield DownloadProgress(progress: downloadedBytes / contentLength);
        }
      }

      yield DownloadProgress(
        progress: 1.0,
        isCompleted: true,
        data: bytesBuilder.takeBytes(),
      );
    } on SocketException {
      yield DownloadProgress(
        progress: 0,
        error: RemoteDataSourceException('No internet connection detected.'),
      );
    } on RemoteDataSourceException catch (e) {
      yield DownloadProgress(progress: 0, error: e);
    } catch (e) {
      yield DownloadProgress(
        progress: 0,
        error: RemoteDataSourceException('An unexpected error occurred: $e'),
      );
    }
  }
}
