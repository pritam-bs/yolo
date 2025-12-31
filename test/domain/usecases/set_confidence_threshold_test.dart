import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/usecases/set_confidence_threshold.dart';

import '../../mocks.mocks.dart';

void main() {
  late SetConfidenceThreshold usecase;
  late YoloRepository mockYoloRepository;

  setUp(() {
    mockYoloRepository = MockYoloRepository();
    usecase = SetConfidenceThreshold(yoloRepository: mockYoloRepository);
  });

  test('should call setConfidenceThreshold on the repository', () {
    // arrange
    const threshold = 0.5;

    // act
    usecase(threshold);

    // assert
    verify(mockYoloRepository.setConfidenceThreshold(threshold));
    verifyNoMoreInteractions(mockYoloRepository);
  });
}