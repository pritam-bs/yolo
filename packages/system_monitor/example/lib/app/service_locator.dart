import 'package:get_it/get_it.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;
import 'package:system_monitor_example/domain/repositories/system_monitor_repository.dart';
import 'package:system_monitor_example/domain/usecases/get_system_metrics.dart';
import 'package:system_monitor_example/infrastructure/repositories/system_monitor_repository_impl.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_bloc.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(() => SystemMetricsBloc(getSystemMetrics: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetSystemMetrics(sl()));

  // Repository
  sl.registerLazySingleton<SystemMonitorRepository>(
    () => SystemMonitorRepositoryImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => plugin.SystemMonitor());
}
