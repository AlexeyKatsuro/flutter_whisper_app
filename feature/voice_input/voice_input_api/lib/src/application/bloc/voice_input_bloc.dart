import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_event.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_state.dart';
import 'package:voice_input_api/src/domain/exceptions/voice_input_exception.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';
import 'package:voice_input_api/src/domain/usecases/check_permissions_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/open_app_settings_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/request_permissions_usecase.dart';

/// BLoC that manages voice input functionality state and events.
///
/// Handles the complete voice input flow from permission requests
/// through recording, transcription, and result delivery.
class VoiceInputBloc extends Bloc<VoiceInputEvent, VoiceInputState> {
  VoiceInputBloc({
    required CheckPermissionsUseCase checkPermissionsUseCase,
    required RequestPermissionsUseCase requestPermissionsUseCase,
    required OpenAppSettingsUseCase openAppSettingsUseCase,
    VoiceInputState? initialState,
  }) : _checkPermissionsUseCase = checkPermissionsUseCase,
       _requestPermissionsUseCase = requestPermissionsUseCase,
       _openAppSettingsUseCase = openAppSettingsUseCase,
       super(
         initialState ??
             const VoiceInputState.idle(
               permission: VoiceInputPermission.denied,
               isOnline: false,
             ),
       ) {
    // Register event handler
    on<VoiceInputEvent>(_onVoiceInputEvent);

    // Initialize with permission check and network monitoring
    _initialize();
  }

  final CheckPermissionsUseCase _checkPermissionsUseCase;
  final RequestPermissionsUseCase _requestPermissionsUseCase;
  final OpenAppSettingsUseCase _openAppSettingsUseCase;
  StreamSubscription<bool>? _networkSubscription;

  /// Initialize the bloc with current permissions and network status.
  Future<void> _initialize() async {
    try {
      final permission = await _checkPermissionsUseCase();

      // Network connectivity monitoring will be implemented in subsequent stories
      // For now, just use a placeholder
      const isOnline = false;

      // Update state based on permission status
      if (permission.canUseVoiceInput) {
        emit(VoiceInputState.idle(permission: permission, isOnline: isOnline));
      } else if (permission.canRequestAnyPermission) {
        emit(VoiceInputState.idle(permission: permission, isOnline: isOnline));
      } else {
        emit(VoiceInputState.permissionDenied(permission: permission));
      }
    } catch (error) {
      // If initialization fails, stay in initial state
      // Error handling will be implemented in Story 09
    }
  }

  // Event Handler
  Future<void> _onVoiceInputEvent(VoiceInputEvent event, Emitter<VoiceInputState> emit) async {
    await event.when(
      permissionRequested: () => _onPermissionRequested(emit),
      recordingStarted: () => _onRecordingStarted(emit),
      recordingStopped: () => _onRecordingStopped(emit),
      recordingCancelled: () => _onRecordingCancelled(emit),
      transcriptionRequested: (recording, preferOnline) =>
          _onTranscriptionRequested(recording, preferOnline, emit),
      transcriptionRetried: () => _onTranscriptionRetried(emit),
      errorDismissed: () => _onErrorDismissed(emit),
      settingsOpened: () => _onSettingsOpened(emit),
    );
  }

  /// Handles permission request event.
  Future<void> _onPermissionRequested(Emitter<VoiceInputState> emit) async {
    emit(const VoiceInputState.permissionRequesting());

    try {
      final permission = await _requestPermissionsUseCase();
      const isOnline = false; // Network connectivity will be implemented later

      if (permission.canUseVoiceInput) {
        emit(VoiceInputState.idle(permission: permission, isOnline: isOnline));
      } else {
        emit(VoiceInputState.permissionDenied(permission: permission));
      }
    } catch (error) {
      if (error is PermissionDeniedException) {
        // Re-check permissions to get current state
        try {
          final permission = await _checkPermissionsUseCase();
          emit(VoiceInputState.permissionDenied(permission: permission));
        } catch (_) {
          emit(const VoiceInputState.permissionDenied(permission: VoiceInputPermission.denied));
        }
      } else {
        // Handle other errors - for now just emit error state
        emit(
          VoiceInputState.error(
            error: error is VoiceInputException
                ? error
                : RecordingException('Permission request failed'),
            canRetry: true,
          ),
        );
      }
    }
  }

  /// Handles app settings opening event.
  Future<void> _onSettingsOpened(Emitter<VoiceInputState> emit) async {
    try {
      await _openAppSettingsUseCase();

      // After opening settings, check permissions again when user returns
      // This will be handled by app lifecycle events in a future story
    } catch (error) {
      // If opening settings fails, just continue - not critical
    }
  }

  // Placeholder implementations for future stories
  Future<void> _onRecordingStarted(Emitter<VoiceInputState> emit) async {
    // TODO: Implement in Story 03 - Audio Recording
  }

  Future<void> _onRecordingStopped(Emitter<VoiceInputState> emit) async {
    // TODO: Implement in Story 03 - Audio Recording
  }

  Future<void> _onRecordingCancelled(Emitter<VoiceInputState> emit) async {
    // TODO: Implement in Story 03 - Audio Recording
  }

  Future<void> _onTranscriptionRequested(
    VoiceRecording recording,
    bool preferOnline,
    Emitter<VoiceInputState> emit,
  ) async {
    // TODO: Implement in Stories 04-05 - Transcription
  }

  Future<void> _onTranscriptionRetried(Emitter<VoiceInputState> emit) async {
    // TODO: Implement in Story 09 - Error Handling
  }

  Future<void> _onErrorDismissed(Emitter<VoiceInputState> emit) async {
    // TODO: Implement in Story 09 - Error Handling
  }

  @override
  Future<void> close() async {
    await _networkSubscription?.cancel();
    return super.close();
  }
}
