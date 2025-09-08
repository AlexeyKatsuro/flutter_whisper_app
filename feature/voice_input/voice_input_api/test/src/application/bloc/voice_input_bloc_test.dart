import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_bloc.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_event.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_state.dart';
import 'package:voice_input_api/src/domain/exceptions/voice_input_exception.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/usecases/check_permissions_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/open_app_settings_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/request_permissions_usecase.dart';

import 'voice_input_bloc_test.mocks.dart';

@GenerateMocks([
  CheckPermissionsUseCase,
  RequestPermissionsUseCase,
  OpenAppSettingsUseCase,
])
void main() {
  group('VoiceInputBloc', () {
    late MockCheckPermissionsUseCase mockCheckPermissionsUseCase;
    late MockRequestPermissionsUseCase mockRequestPermissionsUseCase;
    late MockOpenAppSettingsUseCase mockOpenAppSettingsUseCase;

    setUp(() {
      mockCheckPermissionsUseCase = MockCheckPermissionsUseCase();
      mockRequestPermissionsUseCase = MockRequestPermissionsUseCase();
      mockOpenAppSettingsUseCase = MockOpenAppSettingsUseCase();
    });

    VoiceInputBloc createBloc({VoiceInputState? initialState}) {
      return VoiceInputBloc(
        checkPermissionsUseCase: mockCheckPermissionsUseCase,
        requestPermissionsUseCase: mockRequestPermissionsUseCase,
        openAppSettingsUseCase: mockOpenAppSettingsUseCase,
        initialState: initialState,
      );
    }

    group('initialization', () {
      test('has correct initial state', () {
        const expectedInitialState = VoiceInputState.idle(
          permission: VoiceInputPermission.denied,
          isOnline: false,
        );

        final bloc = createBloc();
        expect(bloc.state, equals(expectedInitialState));
      });

      test('uses provided initial state', () {
        const customInitialState = VoiceInputState.permissionDenied(
          permission: VoiceInputPermission.denied,
        );

        final bloc = createBloc(initialState: customInitialState);
        expect(bloc.state, equals(customInitialState));
      });
    });

    group('permissionRequested', () {
      test('emits permissionRequesting then idle when microphone permission is granted', () async {
        // Arrange
        const grantedPermissions = VoiceInputPermission(
          microphoneGranted: true,
          speechRecognitionGranted: true,
          canRequestMicrophone: false,
          canRequestSpeechRecognition: false,
        );

        when(mockRequestPermissionsUseCase()).thenAnswer((_) async => grantedPermissions);

        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        // Wait for initialization to complete
        await Future.delayed(const Duration(milliseconds: 50));
        states.clear(); // Clear states from initialization

        // Act
        bloc.add(const VoiceInputEvent.permissionRequested());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(states, [
          const VoiceInputState.permissionRequesting(),
          const VoiceInputState.idle(
            permission: VoiceInputPermission(
              microphoneGranted: true,
              speechRecognitionGranted: true,
              canRequestMicrophone: false,
              canRequestSpeechRecognition: false,
            ),
            isOnline: false,
          ),
        ]);

        verify(mockRequestPermissionsUseCase()).called(1);
        await subscription.cancel();
        await bloc.close();
      });

      test(
        'emits permissionRequesting then permissionDenied when microphone permission is denied',
        () async {
          // Arrange
          const deniedPermissions = VoiceInputPermission(
            microphoneGranted: false,
            speechRecognitionGranted: false,
            canRequestMicrophone: false,
            canRequestSpeechRecognition: false,
          );

          when(mockRequestPermissionsUseCase()).thenAnswer((_) async => deniedPermissions);

          final bloc = createBloc();
          final states = <VoiceInputState>[];
          final subscription = bloc.stream.listen(states.add);

          // Wait for initialization to complete
          await Future.delayed(const Duration(milliseconds: 50));
          states.clear(); // Clear states from initialization

          // Act
          bloc.add(const VoiceInputEvent.permissionRequested());
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [
            const VoiceInputState.permissionRequesting(),
            const VoiceInputState.permissionDenied(
              permission: VoiceInputPermission(
                microphoneGranted: false,
                speechRecognitionGranted: false,
                canRequestMicrophone: false,
                canRequestSpeechRecognition: false,
              ),
            ),
          ]);

          verify(mockRequestPermissionsUseCase()).called(1);
          await subscription.cancel();
          await bloc.close();
        },
      );

      test('handles PermissionDeniedException correctly', () async {
        // Arrange
        const deniedPermissions = VoiceInputPermission.denied;

        when(mockRequestPermissionsUseCase()).thenThrow(const PermissionDeniedException());

        when(mockCheckPermissionsUseCase()).thenAnswer((_) async => deniedPermissions);

        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        // Wait for initialization to complete
        await Future.delayed(const Duration(milliseconds: 50));
        states.clear(); // Clear states from initialization

        // Act
        bloc.add(const VoiceInputEvent.permissionRequested());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(states, [
          const VoiceInputState.permissionRequesting(),
          const VoiceInputState.permissionDenied(permission: VoiceInputPermission.denied),
        ]);

        verify(mockRequestPermissionsUseCase()).called(1);
        verify(
          mockCheckPermissionsUseCase(),
        ).called(2); // Called during initialization and error handling
        await subscription.cancel();
        await bloc.close();
      });
    });

    group('settingsOpened', () {
      test('calls openAppSettings use case', () async {
        // Arrange
        when(mockOpenAppSettingsUseCase()).thenAnswer((_) async => {});

        final bloc = createBloc();

        // Act
        bloc.add(const VoiceInputEvent.settingsOpened());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        verify(mockOpenAppSettingsUseCase()).called(1);
        await bloc.close();
      });

      test('handles openAppSettings exception gracefully', () async {
        // Arrange
        when(mockOpenAppSettingsUseCase()).thenThrow(Exception('Failed to open settings'));

        final bloc = createBloc();

        // Act
        bloc.add(const VoiceInputEvent.settingsOpened());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        verify(mockOpenAppSettingsUseCase()).called(1);
        await bloc.close();
      });
    });

    group('placeholder events', () {
      test('recordingStarted does nothing (placeholder)', () async {
        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const VoiceInputEvent.recordingStarted());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states, isEmpty);
        await subscription.cancel();
        await bloc.close();
      });

      test('recordingStopped does nothing (placeholder)', () async {
        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const VoiceInputEvent.recordingStopped());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states, isEmpty);
        await subscription.cancel();
        await bloc.close();
      });

      test('recordingCancelled does nothing (placeholder)', () async {
        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const VoiceInputEvent.recordingCancelled());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states, isEmpty);
        await subscription.cancel();
        await bloc.close();
      });

      test('transcriptionRetried does nothing (placeholder)', () async {
        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const VoiceInputEvent.transcriptionRetried());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states, isEmpty);
        await subscription.cancel();
        await bloc.close();
      });

      test('errorDismissed does nothing (placeholder)', () async {
        final bloc = createBloc();
        final states = <VoiceInputState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const VoiceInputEvent.errorDismissed());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states, isEmpty);
        await subscription.cancel();
        await bloc.close();
      });
    });
  });
}
