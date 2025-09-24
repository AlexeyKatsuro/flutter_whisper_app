import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voice_input_api/src/data/datasources/permission_datasource.dart';
import 'package:voice_input_api/src/data/repositories/voice_input_repository_impl.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';

import 'voice_input_repository_impl_test.mocks.dart';

@GenerateMocks([PermissionDataSource])
void main() {
  group('VoiceInputRepositoryImpl', () {
    late VoiceInputRepositoryImpl repository;
    late MockPermissionDataSource mockPermissionDataSource;
    late Logger logger;

    setUp(() {
      mockPermissionDataSource = MockPermissionDataSource();
      logger = Logger();

      repository = VoiceInputRepositoryImpl(
        permissionDataSource: mockPermissionDataSource,
        logger: logger,
      );
    });

    group('checkPermissions', () {
      test('returns permissions from data source when successful', () async {
        // Arrange
        const expectedPermissions = VoiceInputPermission(
          microphoneGranted: true,
          speechRecognitionGranted: true,
          canRequestMicrophone: false,
          canRequestSpeechRecognition: false,
        );

        when(
          mockPermissionDataSource.checkPermissions(),
        ).thenAnswer((_) async => expectedPermissions);

        // Act
        final result = await repository.checkPermissions();

        // Assert
        expect(result, equals(expectedPermissions));
        verify(mockPermissionDataSource.checkPermissions()).called(1);
      });

      test('logs error and rethrows when data source throws exception', () async {
        // Arrange
        final exception = Exception('Permission check failed');
        when(mockPermissionDataSource.checkPermissions()).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.checkPermissions(),
          throwsA(equals(exception)),
        );

        verify(mockPermissionDataSource.checkPermissions()).called(1);
      });

      test('handles different permission states correctly', () async {
        // Arrange
        const deniedPermissions = VoiceInputPermission(
          microphoneGranted: false,
          speechRecognitionGranted: false,
          canRequestMicrophone: true,
          canRequestSpeechRecognition: true,
        );

        when(
          mockPermissionDataSource.checkPermissions(),
        ).thenAnswer((_) async => deniedPermissions);

        // Act
        final result = await repository.checkPermissions();

        // Assert
        expect(result, equals(deniedPermissions));
        expect(result.microphoneGranted, isFalse);
        expect(result.canRequestMicrophone, isTrue);
      });
    });

    group('requestPermissions', () {
      test('returns permissions from data source when successful', () async {
        // Arrange
        const expectedPermissions = VoiceInputPermission(
          microphoneGranted: true,
          speechRecognitionGranted: false,
          canRequestMicrophone: false,
          canRequestSpeechRecognition: true,
        );

        when(
          mockPermissionDataSource.requestPermissions(),
        ).thenAnswer((_) async => expectedPermissions);

        // Act
        final result = await repository.requestPermissions();

        // Assert
        expect(result, equals(expectedPermissions));
        verify(mockPermissionDataSource.requestPermissions()).called(1);
      });

      test('logs error and rethrows when data source throws exception', () async {
        // Arrange
        final exception = Exception('Permission request failed');
        when(mockPermissionDataSource.requestPermissions()).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.requestPermissions(),
          throwsA(equals(exception)),
        );

        verify(mockPermissionDataSource.requestPermissions()).called(1);
      });

      test('handles permission denial correctly', () async {
        // Arrange
        const deniedPermissions = VoiceInputPermission(
          microphoneGranted: false,
          speechRecognitionGranted: false,
          canRequestMicrophone: false,
          canRequestSpeechRecognition: false,
        );

        when(
          mockPermissionDataSource.requestPermissions(),
        ).thenAnswer((_) async => deniedPermissions);

        // Act
        final result = await repository.requestPermissions();

        // Assert
        expect(result, equals(deniedPermissions));
        expect(result.canUseVoiceInput, isFalse);
      });
    });

    group('openAppSettings', () {
      test('calls data source openAppSettings and clears cache when successful', () async {
        // Arrange
        when(mockPermissionDataSource.openAppSettings()).thenAnswer((_) async {});

        // Act
        await repository.openAppSettings();

        // Assert
        verify(mockPermissionDataSource.openAppSettings()).called(1);
        verify(mockPermissionDataSource.clearPermissionCache()).called(1);
      });

      test('logs error and rethrows when data source throws exception', () async {
        // Arrange
        final exception = Exception('Failed to open settings');
        when(mockPermissionDataSource.openAppSettings()).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.openAppSettings(),
          throwsA(equals(exception)),
        );

        verify(mockPermissionDataSource.openAppSettings()).called(1);
        // Cache should not be cleared if operation failed
        verifyNever(mockPermissionDataSource.clearPermissionCache());
      });
    });

    group('cleanup', () {
      test('clears permission cache when called', () async {
        // Act
        await repository.cleanup();

        // Assert
        verify(mockPermissionDataSource.clearPermissionCache()).called(1);
      });
    });

    group('unimplemented methods', () {
      test('startRecording throws UnimplementedError with correct message', () {
        expect(
          () => repository.startRecording(),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Audio recording will be implemented in Story 03',
            ),
          ),
        );
      });

      test('stopRecording throws UnimplementedError with correct message', () {
        expect(
          () => repository.stopRecording(),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Audio recording will be implemented in Story 03',
            ),
          ),
        );
      });

      test('cancelRecording throws UnimplementedError with correct message', () {
        expect(
          () => repository.cancelRecording('test-id'),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Audio recording will be implemented in Story 03',
            ),
          ),
        );
      });

      test('transcribeOnline throws UnimplementedError with correct message', () {
        expect(
          () => repository.transcribeOnline(
            VoiceRecording(
              id: 'test',
              filePath: '/test/path',
              duration: const Duration(seconds: 5),
              createdAt: DateTime.now(),
              status: VoiceRecordingStatus.recorded,
            ),
          ),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Online transcription will be implemented in Story 05',
            ),
          ),
        );
      });

      test('transcribeOffline throws UnimplementedError with correct message', () {
        expect(
          () => repository.transcribeOffline(
            VoiceRecording(
              id: 'test',
              filePath: '/test/path',
              duration: const Duration(seconds: 5),
              createdAt: DateTime.now(),
              status: VoiceRecordingStatus.recorded,
            ),
          ),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Offline transcription will be implemented in Story 04',
            ),
          ),
        );
      });

      test('networkConnectivity getter throws UnimplementedError with correct message', () {
        expect(
          () => repository.networkConnectivity,
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'Network connectivity will be implemented in Story 03',
            ),
          ),
        );
      });
    });
  });
}
