import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  http.Client get client => http.Client();

  @lazySingleton
  FileSystem get fileSystem => const LocalFileSystem();
}
