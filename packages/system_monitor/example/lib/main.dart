import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_monitor_example/app/injection.dart';
import 'package:system_monitor_example/domain/repositories/system_monitor_repository.dart'; // New import
import 'package:system_monitor_example/presentation/bloc/system_metrics_bloc.dart';
import 'package:system_monitor_example/presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  getIt<SystemMonitorRepository>().start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Monitor Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => getIt<SystemMetricsBloc>(),
        child: const HomePage(),
      ),
    );
  }
}
