import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yolo/domain/entities/system_health_state.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/usecases/set_streaming_config.dart';

import '../../mocks.mocks.dart';

void main() {
  late SetStreamingConfig usecase;
  late YoloRepository mockYoloRepository;

  setUp(() {
    mockYoloRepository = MockYoloRepository();
    usecase = SetStreamingConfig(mockYoloRepository);
  });

  test('should call setStreamingConfig on the repository', () {
    // arrange
    const health = SystemHealthState.normal;

    // act
    usecase(health);

    // assert
    verify(mockYoloRepository.setStreamingConfig(health));
    verifyNoMoreInteractions(mockYoloRepository);
  });
}
