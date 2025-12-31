import 'package:mockito/annotations.dart';
import 'package:yolo/application/blocs/camera_inference/camera_inference_bloc.dart';
import 'package:yolo/data/datasources/local_model_data_source.dart';
import 'package:yolo/data/datasources/remote_model_data_source.dart';
import 'package:yolo/domain/repositories/system_monitor_repository.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';

@GenerateMocks([
  SystemMonitorRepository,
  YoloRepository,
  YOLOViewController,
  LocalModelDataSource,
  RemoteModelDataSource,
  CameraInferenceBloc,
])
void main() {}
