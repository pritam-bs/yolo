// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file/file.dart' as _i303;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:system_monitor/system_monitor.dart' as _i407;

import 'application/blocs/camera_inference/camera_inference_bloc.dart' as _i655;
import 'data/datasources/app_module.dart' as _i530;
import 'data/datasources/local_model_data_source.dart' as _i789;
import 'data/datasources/remote_model_data_source.dart' as _i992;
import 'data/repositories/system_monitor_repository_impl.dart' as _i570;
import 'data/repositories/yolo_repository_impl.dart' as _i320;
import 'domain/repositories/system_monitor_repository.dart' as _i222;
import 'domain/repositories/yolo_repository.dart' as _i25;
import 'domain/usecases/flip_camera.dart' as _i638;
import 'domain/usecases/get_model_path.dart' as _i584;
import 'domain/usecases/get_system_metrics.dart' as _i619;
import 'domain/usecases/set_confidence_threshold.dart' as _i659;
import 'domain/usecases/set_iou_threshold.dart' as _i837;
import 'domain/usecases/set_num_items_threshold.dart' as _i965;
import 'domain/usecases/set_streaming_config.dart' as _i536;
import 'domain/usecases/set_thresholds.dart' as _i390;
import 'domain/usecases/set_zoom_level.dart' as _i649;
import 'domain/usecases/system_metrics_monitor_dispose.dart' as _i1024;
import 'domain/usecases/system_metrics_monitor_start.dart' as _i708;
import 'domain/usecases/system_metrics_monitor_stop.dart' as _i586;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final appModule = _$AppModule();
  gh.lazySingleton<_i519.Client>(() => appModule.client);
  gh.lazySingleton<_i303.FileSystem>(() => appModule.fileSystem);
  gh.lazySingleton<_i407.SystemMonitor>(() => appModule.systemMonitor);
  gh.lazySingleton<_i992.RemoteModelDataSource>(
    () => _i992.RemoteModelDataSource(gh<_i519.Client>()),
  );
  gh.lazySingleton<_i222.SystemMonitorRepository>(
    () => _i570.SystemMonitorRepositoryImpl(gh<_i407.SystemMonitor>()),
  );
  gh.factory<_i789.LocalModelDataSource>(
    () => _i789.LocalModelDataSourceImpl(gh<_i303.FileSystem>()),
  );
  gh.lazySingleton<_i25.YoloRepository>(
    () => _i320.YoloRepositoryImpl(
      localModelDataSource: gh<_i789.LocalModelDataSource>(),
      remoteModelDataSource: gh<_i992.RemoteModelDataSource>(),
    ),
  );
  gh.lazySingleton<_i619.GetSystemMetrics>(
    () => _i619.GetSystemMetrics(gh<_i222.SystemMonitorRepository>()),
  );
  gh.lazySingleton<_i1024.SystemMetricsMonitorDispose>(
    () =>
        _i1024.SystemMetricsMonitorDispose(gh<_i222.SystemMonitorRepository>()),
  );
  gh.lazySingleton<_i708.SystemMetricsMonitorStart>(
    () => _i708.SystemMetricsMonitorStart(gh<_i222.SystemMonitorRepository>()),
  );
  gh.lazySingleton<_i586.SystemMetricsMonitorStop>(
    () => _i586.SystemMetricsMonitorStop(gh<_i222.SystemMonitorRepository>()),
  );
  gh.factory<_i536.SetStreamingConfig>(
    () => _i536.SetStreamingConfig(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i638.FlipCamera>(
    () => _i638.FlipCamera(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i584.GetModelPath>(
    () => _i584.GetModelPath(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i659.SetConfidenceThreshold>(
    () =>
        _i659.SetConfidenceThreshold(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i837.SetIoUThreshold>(
    () => _i837.SetIoUThreshold(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i965.SetNumItemsThreshold>(
    () => _i965.SetNumItemsThreshold(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i390.SetThresholds>(
    () => _i390.SetThresholds(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i649.SetZoomLevel>(
    () => _i649.SetZoomLevel(yoloRepository: gh<_i25.YoloRepository>()),
  );
  gh.factory<_i655.CameraInferenceBloc>(
    () => _i655.CameraInferenceBloc(
      getModelPath: gh<_i584.GetModelPath>(),
      flipCamera: gh<_i638.FlipCamera>(),
      setConfidenceThreshold: gh<_i659.SetConfidenceThreshold>(),
      setIoUThreshold: gh<_i837.SetIoUThreshold>(),
      setNumItemsThreshold: gh<_i965.SetNumItemsThreshold>(),
      setZoomLevel: gh<_i649.SetZoomLevel>(),
      setThresholds: gh<_i390.SetThresholds>(),
      setStreamingConfig: gh<_i536.SetStreamingConfig>(),
      getSystemMetrics: gh<_i619.GetSystemMetrics>(),
      systemMetricsMonitorStart: gh<_i708.SystemMetricsMonitorStart>(),
      systemMetricsMonitorStop: gh<_i586.SystemMetricsMonitorStop>(),
      systemMetricsMonitorDispose: gh<_i1024.SystemMetricsMonitorDispose>(),
    ),
  );
  return getIt;
}

class _$AppModule extends _i530.AppModule {}
