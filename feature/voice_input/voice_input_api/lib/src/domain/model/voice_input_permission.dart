import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_input_permission.freezed.dart';
part 'voice_input_permission.g.dart';

/// Represents the current permission status for voice input functionality.
@freezed
class VoiceInputPermission with _$VoiceInputPermission {
  const factory VoiceInputPermission({
    required bool microphoneGranted,
    required bool speechRecognitionGranted,
    required bool canRequestMicrophone,
    required bool canRequestSpeechRecognition,
  }) = _VoiceInputPermission;

  factory VoiceInputPermission.fromJson(Map<String, dynamic> json) =>
      _$VoiceInputPermissionFromJson(json);

  /// Creates a permission object representing all permissions denied.
  static const denied = VoiceInputPermission(
    microphoneGranted: false,
    speechRecognitionGranted: false,
    canRequestMicrophone: false,
    canRequestSpeechRecognition: false,
  );

  /// Creates a permission object representing all permissions granted.
  static const granted = VoiceInputPermission(
    microphoneGranted: true,
    speechRecognitionGranted: true,
    canRequestMicrophone: true,
    canRequestSpeechRecognition: true,
  );
}

extension VoiceInputPermissionExtensions on VoiceInputPermission {
  /// Whether voice input is fully available (microphone permission granted).
  bool get canUseVoiceInput => microphoneGranted;

  /// Whether offline transcription is available.
  bool get canUseOfflineTranscription => speechRecognitionGranted;

  /// Whether any permission can still be requested.
  bool get canRequestAnyPermission => canRequestMicrophone || canRequestSpeechRecognition;
}
