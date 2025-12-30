import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:system_monitor_example/domain/usecases/get_system_metrics.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_event.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_state.dart';

@injectable
class SystemMetricsBloc extends Bloc<SystemMetricsEvent, SystemMetricsState> {
  final GetSystemMetrics getSystemMetrics;
  StreamSubscription? _metricsSubscription;

  SystemMetricsBloc({required this.getSystemMetrics})
    : super(SystemMetricsInitial()) {
    on<GetSystemMetricsEvent>((event, emit) {
      _metricsSubscription?.cancel();
      _metricsSubscription = getSystemMetrics().listen(
        (metrics) => add(UpdateSystemMetricsEvent(metrics)),
        onError: (error) => emit(SystemMetricsError(error.toString())),
      );
    });

    on<UpdateSystemMetricsEvent>((event, emit) {
      emit(SystemMetricsLoaded(event.metrics));
    });
  }

  @override
  Future<void> close() {
    _metricsSubscription?.cancel();
    return super.close();
  }
}
