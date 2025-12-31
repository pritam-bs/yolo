import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_event.dart';
import 'package:yolo/application/screens/camera_inference_screen.dart';

import 'application/blocs/camera_inference/camera_inference_bloc.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOLO',
      home: BlocProvider(
        create: (_) =>
            getIt<CameraInferenceBloc>()..add(const InitializeCamera()),
        child: const CameraInferenceScreen(),
      ),
    );
  }
}
