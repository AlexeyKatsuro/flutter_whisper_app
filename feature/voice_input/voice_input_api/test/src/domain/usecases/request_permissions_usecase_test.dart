import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voice_input_api/src/domain/exceptions/voice_input_exception.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/repositories/voice_input_repository.dart';
import 'package:voice_input_api/src/domain/usecases/request_permissions_usecase.dart';

import 'request_permissions_usecase_test.mocks.dart';

@GenerateMocks([VoiceInputRepository])
void main() {
  group('RequestPermissionsUseCase', () {
    late MockVoiceInputRepository mockRepository;
    late RequestPermissionsUseCase useCase;

    setUp(() {
      mockRepository = MockVoiceInputRepository();
      useCase = RequestPermissionsUseCase(mockRepository);
    });

    test('returns permissions when microphone is granted', () async {
      // Arrange
      const expectedPermissions = VoiceInputPermission(
        microphoneGranted: true,
        speechRecognitionGranted: true,
        canRequestMicrophone: false,
        canRequestSpeechRecognition: false,
      );

      when(mockRepository.requestPermissions()).thenAnswer((_) async => expectedPermissions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(expectedPermissions));
      verify(mockRepository.requestPermissions()).called(1);
    });

    test('returns permissions when microphone is granted but speech is denied', () async {
      // Arrange
      const expectedPermissions = VoiceInputPermission(
        microphoneGranted: true,
        speechRecognitionGranted: false,
        canRequestMicrophone: false,
        canRequestSpeechRecognition: true,
      );

      when(mockRepository.requestPermissions()).thenAnswer((_) async => expectedPermissions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(expectedPermissions));
      verify(mockRepository.requestPermissions()).called(1);
    });

    test('throws PermissionDeniedException when microphone is permanently denied', () async {
      // Arrange
      const deniedPermissions = VoiceInputPermission(
        microphoneGranted: false,
        speechRecognitionGranted: false,
        canRequestMicrophone: false, // Permanently denied
        canRequestSpeechRecognition: false,
      );

      when(mockRepository.requestPermissions()).thenAnswer((_) async => deniedPermissions);

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<PermissionDeniedException>()),
      );
      verify(mockRepository.requestPermissions()).called(1);
    });

    test('returns permissions when microphone is denied but can still be requested', () async {
      // Arrange
      const deniedPermissions = VoiceInputPermission(
        microphoneGranted: false,
        speechRecognitionGranted: false,
        canRequestMicrophone: true, // Can still request
        canRequestSpeechRecognition: true,
      );

      when(mockRepository.requestPermissions()).thenAnswer((_) async => deniedPermissions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(deniedPermissions));
      verify(mockRepository.requestPermissions()).called(1);
    });

    test('forwards other exceptions from repository', () async {
      // Arrange
      final exception = Exception('Network error');
      when(mockRepository.requestPermissions()).thenThrow(exception);

      // Act & Assert
      expect(() => useCase(), throwsA(equals(exception)));
      verify(mockRepository.requestPermissions()).called(1);
    });
  });
}
