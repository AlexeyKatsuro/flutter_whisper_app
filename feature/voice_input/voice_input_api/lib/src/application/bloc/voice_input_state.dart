import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_input_api/src/domain/exceptions/voice_input_exception.dart';
import 'package:voice_input_api/src/domain/model/transcription_result.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';

part 'voice_input_state.freezed.dart';

/// States that the [VoiceInputBloc] can be in.
@freezed
sealed class VoiceInputState with _$VoiceInputState {
  /// Initial idle state where voice input is available.
  const factory VoiceInputState.idle({
    required VoiceInputPermission permission,
    required bool isOnline,
  }) = _Idle;

  /// State when requesting permissions from the user.
  const factory VoiceInputState.permissionRequesting() = _PermissionRequesting;

  /// State when permissions are denied and voice input is unavailable.
  const factory VoiceInputState.permissionDenied({
    required VoiceInputPermission permission,
  }) = _PermissionDenied;

  /// State when actively recording audio.
  const factory VoiceInputState.recording({
    required VoiceRecording recording,
    required bool isOnline,
  }) = _Recording;

  /// State when processing recorded audio for transcription.
  const factory VoiceInputState.processing({
    required VoiceRecording recording,
    required TranscriptionMode mode,
  }) = _Processing;

  /// State when transcription completed successfully.
  const factory VoiceInputState.success({
    required TranscriptionResult result,
    required bool isOnline,
  }) = _Success;

  /// State when an error occurred during voice input process.
  const factory VoiceInputState.error({
    required VoiceInputException error,
    required bool canRetry,
    VoiceRecording? recording,
  }) = _Error;
}
