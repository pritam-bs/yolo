import 'dart:async';
import 'package:flutter/services.dart';

/// An enum representing the thermal state of the device.
enum ThermalState {
  /// The device is operating under normal thermal conditions.
  nominal,

  /// The device is slightly warm, but no corrective action is needed.
  fair,

  /// The device is warm and performance may be throttled.
  serious,

  /// The device is critically hot and significant performance throttling is occurring.
  critical,

  /// The thermal state is not supported on this platform or OS version.
  unsupported,

  /// The thermal state could not be determined.
  unknown,
}

/// A data class to hold a snapshot of system metrics.
///
/// This immutable class encapsulates various hardware status metrics,
/// including battery level, RAM usage, and the device's
/// thermal state.
class SystemMetrics {
  /// The device's battery level, from 0 to 100.
  /// A value of -1 indicates that the battery level is unknown or
  /// not available.
  final int batteryLevel;

  /// The current RAM usage as a percentage, from 0.0 to 1.0.
  /// On Android, this represents system-wide RAM usage.
  /// On iOS, this represents the app's resident memory usage.
  final double ramUsage;

  /// The thermal state of the device.
  final ThermalState thermalState;

  /// Creates a [SystemMetrics] object with the given hardware status data.
  SystemMetrics({
    required this.batteryLevel,
    required this.ramUsage,
    required this.thermalState,
  });

  /// Creates a [SystemMetrics] object from a map representation.
  ///
  /// This factory constructor is typically used to deserialize data
  /// received from the platform channel.
  factory SystemMetrics.fromMap(Map<dynamic, dynamic> map) {
    return SystemMetrics(
      batteryLevel: map['batteryLevel'] as int? ?? -1,
      ramUsage: map['ramUsage']?.toDouble() ?? 0.0,
      thermalState: _thermalStateFromString(map['thermalState'] as String?),
    );
  }

  static ThermalState _thermalStateFromString(String? state) {
    switch (state) {
      case 'nominal':
        return ThermalState.nominal;
      case 'fair':
        return ThermalState.fair;
      case 'serious':
        return ThermalState.serious;
      case 'critical':
        return ThermalState.critical;
      case 'unsupported':
        return ThermalState.unsupported;
      default:
        return ThermalState.unknown;
    }
  }

  @override
  String toString() {
    return 'SystemMetrics(battery: $batteryLevel%, '
        'ram: ${ramUsage.toStringAsFixed(1)}%, '
        'thermal: ${thermalState.toString().split('.').last})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemMetrics &&
          runtimeType == other.runtimeType &&
          batteryLevel == other.batteryLevel &&
          ramUsage == other.ramUsage &&
          thermalState == other.thermalState;

  @override
  int get hashCode =>
      batteryLevel.hashCode ^ ramUsage.hashCode ^ thermalState.hashCode;
}

/// A class to monitor device system metrics like RAM, battery, and thermal state.
///
/// Use this class to start and stop the monitoring service and to subscribe
/// to a stream of [SystemMetrics] updates.
class SystemMonitor {
  static const EventChannel _eventChannel = EventChannel(
    'system_monitor/metrics',
  );

  late final StreamController<SystemMetrics> _controller;
  StreamSubscription<dynamic>? _platformSubscription;

  /// A broadcast stream of [SystemMetrics] that emits data at a regular interval.
  ///
  /// This stream begins emitting data once [start] is called and stops when
  /// [stop] is called. Listeners will receive updates as long as the monitoring
  /// is active.
  late final Stream<SystemMetrics> metricsStream;

  SystemMonitor() {
    _controller = StreamController<SystemMetrics>.broadcast();
    metricsStream = _controller.stream;
  }

  /// Starts the system monitoring service.
  ///
  /// The plugin will begin collecting data and emitting [SystemMetrics]
  /// objects on the [metricsStream]. If the service is already active,
  /// this method does nothing.
  ///
  /// [interval] specifies the time between metric updates. A shorter
  /// interval provides more responsive data but consumes slightly more
  /// battery. A recommended value is between 2 to 5 seconds.
  /// The minimum interval is 500 milliseconds.
  void start({Duration interval = const Duration(seconds: 3)}) {
    if (_platformSubscription != null) {
      // Already active
      return;
    }

    final effectiveInterval = interval.inMilliseconds < 500
        ? const Duration(milliseconds: 500)
        : interval;

    _platformSubscription = _eventChannel
        .receiveBroadcastStream({'interval': effectiveInterval.inMilliseconds})
        .map((dynamic event) => SystemMetrics.fromMap(event))
        .listen(
          (metrics) {
            _controller.add(metrics);
          },
          onError: (error) {
            _controller.addError(error);
          },
          onDone: () {
            stop();
          },
        );
  }

  /// Stops the system monitoring service.
  ///
  /// This method cancels the internal platform subscription.
  void stop() {
    _platformSubscription?.cancel();
    _platformSubscription = null;
  }

  /// Disposes the SystemMonitor instance and closes the stream.
  void dispose() {
    stop();
    _controller.close();
  }
}
