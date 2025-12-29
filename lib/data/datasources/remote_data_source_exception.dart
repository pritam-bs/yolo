class RemoteDataSourceException implements Exception {
  final String message;
  final int? statusCode;

  RemoteDataSourceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
