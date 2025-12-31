import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yolo/domain/repositories/yolo_repository.dart';
import 'package:yolo/domain/usecases/set_num_items_threshold.dart';

import '../../mocks.mocks.dart';

void main() {
  late SetNumItemsThreshold usecase;
  late YoloRepository mockYoloRepository;

  setUp(() {
    mockYoloRepository = MockYoloRepository();
    usecase = SetNumItemsThreshold(yoloRepository: mockYoloRepository);
  });

  test('should call setNumItemsThreshold on the repository', () {
    // arrange
    const threshold = 10;

    // act
    usecase(threshold);

    // assert
    verify(mockYoloRepository.setNumItemsThreshold(threshold));
    verifyNoMoreInteractions(mockYoloRepository);
  });
}