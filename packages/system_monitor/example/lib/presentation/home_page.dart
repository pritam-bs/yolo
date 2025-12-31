import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_bloc.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_event.dart';
import 'package:system_monitor_example/presentation/bloc/system_metrics_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<SystemMetricsBloc>().add(GetSystemMetricsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Monitor Example')),
      body: BlocBuilder<SystemMetricsBloc, SystemMetricsState>(
        builder: (context, state) {
          if (state is SystemMetricsInitial || state is SystemMetricsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SystemMetricsLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Battery Level: ${state.metrics.batteryLevel}%'),
                  Text(
                    'RAM Usage: ${(state.metrics.ramUsage * 100).toStringAsFixed(2)}%',
                  ),
                  Text(
                    'Thermal State: ${state.metrics.thermalState.toString().split('.').last}',
                  ),
                ],
              ),
            );
          } else if (state is SystemMetricsError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
