import 'package:equatable/equatable.dart';
import 'package:system_monitor_example/domain/entities/system_metrics.dart';

abstract class SystemMetricsState extends Equatable {
  const SystemMetricsState();

  @override
  List<Object> get props => [];
}

class SystemMetricsInitial extends SystemMetricsState {}

class SystemMetricsLoading extends SystemMetricsState {}

class SystemMetricsLoaded extends SystemMetricsState {
  final SystemMetrics metrics;

  const SystemMetricsLoaded(this.metrics);

  @override
  List<Object> get props => [metrics];
}

class SystemMetricsError extends SystemMetricsState {
  final String message;

  const SystemMetricsError(this.message);

  @override
  List<Object> get props => [message];
}
