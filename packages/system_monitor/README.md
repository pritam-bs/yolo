# System Monitor

A Flutter plugin to monitor device hardware metrics like RAM, battery, and thermal state for performance-adaptive applications.

## Supported Platforms

- **Android**
- **iOS**

## Setup and Installation

1.  Add this to your package's `pubspec.yaml` file:

    ```yaml
    dependencies:
      system_monitor: ^0.1.0
    ```

2.  Install it by running the following command in your terminal:

    ```shell
    flutter pub get
    ```

## Code Example

Here's a complete example of how to use the `SystemMonitor` class to start the stream, listen to `SystemMetrics`, and cancel the subscription.

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:system_monitor/system_monitor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SystemMonitor _systemMonitor = SystemMonitor();
  StreamSubscription<SystemMetrics>? _subscription;
  SystemMetrics? _latestMetrics;

  @override
  void initState() {
    super.initState();
    // Start monitoring at an interval of 2 seconds
    _systemMonitor.start(interval: const Duration(seconds: 2));
    _subscription = _systemMonitor.metricsStream.listen((metrics) {
      setState(() {
        _latestMetrics = metrics;
      });
    });
  }

  @override
  void dispose() {
    // Stop monitoring and cancel the subscription
    _systemMonitor.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('System Monitor Example'),
        ),
        body: Center(
          child: _latestMetrics == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Battery Level: ${_latestMetrics!.batteryLevel}%'),
                    Text('RAM Usage: ${(_latestMetrics!.ramUsage * 100).toStringAsFixed(2)}%'),
                    Text('Thermal State: ${_latestMetrics!.thermalState}'),
                  ],
                ),
        ),
      ),
    );
  }
}
```

## API Reference

### `SystemMonitor`

A class that provides access to the system monitoring functionality.

-   **`Stream<SystemMetrics> get metricsStream`**
    
    A broadcast stream that emits `SystemMetrics` objects at a regular interval. You must call `start()` before you can listen to this stream.
    
-   **`void start({Duration interval = const Duration(seconds: 5)})`**
    
    Starts the system monitoring service.
    
    -   `interval`: The `Duration` between metric updates. The default is 5 seconds.
-   **`void stop()`**
    
    Stops the system monitoring service.

-   **`void dispose()`**

    Disposes the SystemMonitor instance and closes the stream.

### `SystemMetrics`

An immutable data class that holds a snapshot of the system's hardware metrics.

-   **`final int batteryLevel`**
    
    The current battery level as a percentage (0-100).
    
-   **`final double ramUsage`**
    
    The current RAM usage as a percentage (0.0-1.0).
        
-   **`final String thermalState`**
    
    The current thermal state of the device. Possible values are:
    
    -   `nominal`
    -   `fair`
    -   `serious`
    -   `critical`
    -   `unsupported` (if the platform version does not support thermal state monitoring)
    -   `unknown`