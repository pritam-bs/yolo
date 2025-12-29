// ignore_for_file: cascade_invocations

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:yolo/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => initGetIt(getIt);
