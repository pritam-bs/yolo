import 'package:equatable/equatable.dart';
import 'package:system_monitor_example/domain/entities/system_metrics.dart';

abstract class SystemMetricsEvent extends Equatable {
  const SystemMetricsEvent();

  @override
  List<Object> get props => [];
}

class GetSystemMetricsEvent extends SystemMetricsEvent {}

class UpdateSystemMetricsEvent extends SystemMetricsEvent {
  final SystemMetrics metrics;

  const UpdateSystemMetricsEvent(this.metrics);

  @override
  List<Object> get props => [metrics];
}
