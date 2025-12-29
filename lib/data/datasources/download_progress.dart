import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class DownloadProgress extends Equatable {
  final double progress;
  final bool isCompleted;
  final Uint8List? data;
  final Exception? error;

  const DownloadProgress({
    required this.progress,
    this.isCompleted = false,
    this.data,
    this.error,
  });

  @override
  List<Object?> get props => [progress, isCompleted, data, error];

  @override
  String toString() {
    return 'DownloadProgress(progress: $progress, isCompleted: $isCompleted, hasData: ${data != null}, error: $error)';
  }
}
