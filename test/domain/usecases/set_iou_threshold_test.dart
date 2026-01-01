import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/usecases/set_iou_threshold.dart';

import '../../mocks.mocks.dart';

void main() {
  late SetIoUThreshold usecase;
  late YoloRepository mockYoloRepository;

  setUp(() {
    mockYoloRepository = MockYoloRepository();
    usecase = SetIoUThreshold(yoloRepository: mockYoloRepository);
  });

  test('should call setIoUThreshold on the repository', () {
    // arrange
    const threshold = 0.5;

    // act
    usecase(threshold);

    // assert
    verify(mockYoloRepository.setIoUThreshold(threshold));
    verifyNoMoreInteractions(mockYoloRepository);
  });
}
