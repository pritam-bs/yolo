import 'package:http/http.dart' as http show Client;
import 'package:mockito/annotations.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:platform/platform.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/data/datasources/local_model_data_source.dart';
import 'package:yolo/data/datasources/remote_model_data_source.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:system_monitor/system_monitor.dart' as plugin;

// Use cases for CameraInferenceBloc
import 'package:yolo/domain/usecases/get_model_path.dart';
import 'package:yolo/domain/usecases/get_system_metrics.dart';
import 'package:yolo/domain/usecases/set_confidence_threshold.dart';
import 'package:yolo/domain/usecases/set_iou_threshold.dart';
import 'package:yolo/domain/usecases/set_num_items_threshold.dart';
import 'package:yolo/domain/usecases/set_streaming_config.dart';
import 'package:yolo/domain/usecases/set_thresholds.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_dispose.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_start.dart';
import 'package:yolo/domain/usecases/system_metrics_monitor_stop.dart';

// Using `@GenerateMocks` to specify the classes/interfaces to mock.
// Run `dart run build_runner build --delete-conflicting-outputs`
// to generate the mock classes in a file like 'mocks.mocks.dart'.
@GenerateMocks([
  SystemMonitorRepository,
  YoloRepository,
  YOLOViewController,
  LocalModelDataSource,
  RemoteModelDataSource,
  CameraInferenceBloc,
  plugin.SystemMonitor,
  GetModelPath,
  SetConfidenceThreshold,
  SetIoUThreshold,
  SetNumItemsThreshold,
  SetThresholds,
  SetStreamingConfig,
  GetSystemMetrics,
  SystemMetricsMonitorStart,
  SystemMetricsMonitorStop,
  SystemMetricsMonitorDispose,
  PathProviderPlatform,
  http.Client,
  Platform,
])
void main() {}
