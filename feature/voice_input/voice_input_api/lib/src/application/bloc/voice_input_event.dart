import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';

part 'voice_input_event.freezed.dart';

/// Events that can be dispatched to the [VoiceInputBloc].
@freezed
sealed class VoiceInputEvent with _$VoiceInputEvent {
  /// Event to request microphone and speech recognition permissions.
  const factory VoiceInputEvent.permissionRequested() = _PermissionRequested;

  /// Event to start voice recording.
  const factory VoiceInputEvent.recordingStarted() = _RecordingStarted;

  /// Event to stop voice recording and begin transcription.
  const factory VoiceInputEvent.recordingStopped() = _RecordingStopped;

  /// Event to cancel current voice recording.
  const factory VoiceInputEvent.recordingCancelled() = _RecordingCancelled;

  /// Event to request transcription of recorded audio.
  const factory VoiceInputEvent.transcriptionRequested({
    required VoiceRecording recording,
    required bool preferOnline,
  }) = _TranscriptionRequested;

  /// Event to retry transcription after an error.
  const factory VoiceInputEvent.transcriptionRetried() = _TranscriptionRetried;

  /// Event to dismiss current error state.
  const factory VoiceInputEvent.errorDismissed() = _ErrorDismissed;

  /// Event to open app settings for permission management.
  const factory VoiceInputEvent.settingsOpened() = _SettingsOpened;
}
