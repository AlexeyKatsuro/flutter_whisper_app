import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/repositories/voice_input_repository.dart';
import 'package:voice_input_api/src/domain/usecases/check_permissions_usecase.dart';

import 'check_permissions_usecase_test.mocks.dart';

@GenerateMocks([VoiceInputRepository])
void main() {
  group('CheckPermissionsUseCase', () {
    late MockVoiceInputRepository mockRepository;
    late CheckPermissionsUseCase useCase;

    setUp(() {
      mockRepository = MockVoiceInputRepository();
      useCase = CheckPermissionsUseCase(mockRepository);
    });

    test('returns permissions from repository', () async {
      // Arrange
      const expectedPermissions = VoiceInputPermission(
        microphoneGranted: true,
        speechRecognitionGranted: false,
        canRequestMicrophone: false,
        canRequestSpeechRecognition: true,
      );
      
      when(mockRepository.checkPermissions())
          .thenAnswer((_) async => expectedPermissions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(expectedPermissions));
      verify(mockRepository.checkPermissions()).called(1);
    });

    test('forwards exceptions from repository', () async {
      // Arrange
      final exception = Exception('Permission check failed');
      when(mockRepository.checkPermissions()).thenThrow(exception);

      // Act & Assert
      expect(() => useCase(), throwsA(equals(exception)));
      verify(mockRepository.checkPermissions()).called(1);
    });
  });
}
