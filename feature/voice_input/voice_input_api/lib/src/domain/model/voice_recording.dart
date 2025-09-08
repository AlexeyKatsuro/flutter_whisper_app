import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_recording.freezed.dart';
part 'voice_recording.g.dart';

/// Represents a voice recording with its metadata and current status.
@freezed
class VoiceRecording with _$VoiceRecording {
  const factory VoiceRecording({
    required String id,
    required String filePath,
    required Duration duration,
    required DateTime createdAt,
    required VoiceRecordingStatus status,
  }) = _VoiceRecording;

  factory VoiceRecording.fromJson(Map<String, dynamic> json) => _$VoiceRecordingFromJson(json);
}

/// Status of a voice recording throughout its lifecycle.
enum VoiceRecordingStatus {
  /// Currently being recorded
  recording,

  /// Recording completed, ready for transcription
  recorded,

  /// Being processed for transcription
  processing,

  /// Successfully transcribed
  transcribed,

  /// Recording or transcription failed
  failed,
}
