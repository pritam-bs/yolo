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

import 'application/blocs/camera_inference/camera_inference_bloc.dart' as _i655;
import 'data/datasources/app_module.dart' as _i530;
import 'data/datasources/local_model_data_source.dart' as _i789;
import 'data/datasources/remote_model_data_source.dart' as _i992;
import 'data/repositories/yolo_repository_impl.dart' as _i320;
import 'domain/repositories/yolo_repository.dart' as _i25;
import 'domain/usecases/flip_camera.dart' as _i638;
import 'domain/usecases/set_confidence_threshold.dart' as _i659;
import 'domain/usecases/set_iou_threshold.dart' as _i837;
import 'domain/usecases/set_lens_facing.dart' as _i225;
import 'domain/usecases/set_num_items_threshold.dart' as _i965;
import 'domain/usecases/set_zoom_level.dart' as _i649;

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
  gh.lazySingleton<_i992.RemoteModelDataSource>(
    () => _i992.RemoteModelDataSource(gh<_i519.Client>()),
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
  gh.factory<_i638.FlipCamera>(
    () => _i638.FlipCamera(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i659.SetConfidenceThreshold>(
    () => _i659.SetConfidenceThreshold(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i837.SetIoUThreshold>(
    () => _i837.SetIoUThreshold(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i225.SetLensFacing>(
    () => _i225.SetLensFacing(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i965.SetNumItemsThreshold>(
    () => _i965.SetNumItemsThreshold(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i649.SetZoomLevel>(
    () => _i649.SetZoomLevel(gh<_i25.YoloRepository>()),
  );
  gh.factory<_i655.CameraInferenceBloc>(
    () => _i655.CameraInferenceBloc(yoloRepository: gh<_i25.YoloRepository>()),
  );
  return getIt;
}

class _$AppModule extends _i530.AppModule {}
