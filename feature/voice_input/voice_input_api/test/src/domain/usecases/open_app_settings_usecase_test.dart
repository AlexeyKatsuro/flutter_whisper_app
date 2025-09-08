import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voice_input_api/src/domain/repositories/voice_input_repository.dart';
import 'package:voice_input_api/src/domain/usecases/open_app_settings_usecase.dart';

import 'open_app_settings_usecase_test.mocks.dart';

@GenerateMocks([VoiceInputRepository])
void main() {
  group('OpenAppSettingsUseCase', () {
    late MockVoiceInputRepository mockRepository;
    late OpenAppSettingsUseCase useCase;

    setUp(() {
      mockRepository = MockVoiceInputRepository();
      useCase = OpenAppSettingsUseCase(mockRepository);
    });

    test('calls repository openAppSettings method', () async {
      // Arrange
      when(mockRepository.openAppSettings())
          .thenAnswer((_) async => {});

      // Act
      await useCase();

      // Assert
      verify(mockRepository.openAppSettings()).called(1);
    });

    test('forwards exceptions from repository', () async {
      // Arrange
      final exception = Exception('Failed to open settings');
      when(mockRepository.openAppSettings()).thenThrow(exception);

      // Act & Assert
      expect(() => useCase(), throwsA(equals(exception)));
      verify(mockRepository.openAppSettings()).called(1);
    });
  });
}
