import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_metrics.freezed.dart';

@freezed
abstract class SystemMetrics with _$SystemMetrics {
  const factory SystemMetrics({
    required int batteryLevel,
    required double ramUsage,
    required ThermalState thermalState,
  }) = _SystemMetrics;
}

enum ThermalState { nominal, fair, serious, critical, unsupported, unknown }
