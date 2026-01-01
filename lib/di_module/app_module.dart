import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:platform/platform.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';

@module
abstract class AppModule {
  @lazySingleton
  http.Client get client => http.Client();

  @lazySingleton
  FileSystem get fileSystem => const LocalFileSystem();

  @lazySingleton
  plugin.SystemMonitor get systemMonitor => plugin.SystemMonitor();

  @lazySingleton
  YOLOViewController get yoloController => YOLOViewController();

  @lazySingleton
  Platform get platform => const LocalPlatform();
}
