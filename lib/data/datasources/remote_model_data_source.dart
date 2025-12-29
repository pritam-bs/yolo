import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
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

    yield const DownloadProgress(progress: 0.0); // Emit initial progress

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await _client.send(request);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download model: HTTP ${response.statusCode}',
        );
      }

      final contentLength = response.contentLength;
      int downloadedBytes = 0;
      final List<int> bytes = [];

      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        downloadedBytes += chunk.length;
        if (contentLength != null && contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          yield DownloadProgress(progress: progress);
        }
      }

      yield DownloadProgress(
        progress: 1.0,
        isCompleted: true,
        data: Uint8List.fromList(bytes),
      );
    } catch (e) {
      yield DownloadProgress(progress: 0, error: e as Exception);
    }
  }
}
