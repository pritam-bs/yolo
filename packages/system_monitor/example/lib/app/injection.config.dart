// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:system_monitor/system_monitor.dart' as _i407;
import 'package:system_monitor_example/app/injectable_modules.dart' as _i138;
import 'package:system_monitor_example/domain/repositories/system_monitor_repository.dart'
    as _i543;
import 'package:system_monitor_example/domain/usecases/get_system_metrics.dart'
    as _i550;
import 'package:system_monitor_example/infrastructure/repositories/system_monitor_repository_impl.dart'
    as _i744;
import 'package:system_monitor_example/presentation/bloc/system_metrics_bloc.dart'
    as _i525;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i407.SystemMonitor>(() => injectableModule.systemMonitor);
    gh.lazySingleton<_i543.SystemMonitorRepository>(
      () => _i744.SystemMonitorRepositoryImpl(gh<_i407.SystemMonitor>()),
    );
    gh.lazySingleton<_i550.GetSystemMetrics>(
      () => _i550.GetSystemMetrics(gh<_i543.SystemMonitorRepository>()),
    );
    gh.factory<_i525.SystemMetricsBloc>(
      () => _i525.SystemMetricsBloc(
        getSystemMetrics: gh<_i550.GetSystemMetrics>(),
      ),
    );
    return this;
  }
}

class _$InjectableModule extends _i138.InjectableModule {}
