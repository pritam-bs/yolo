import 'package:injectable/injectable.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;

@module
abstract class InjectableModule {
  @lazySingleton
  plugin.SystemMonitor get systemMonitor => plugin.SystemMonitor();
}
