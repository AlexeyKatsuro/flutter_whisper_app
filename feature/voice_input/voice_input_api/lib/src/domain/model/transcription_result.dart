import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcription_result.freezed.dart';
part 'transcription_result.g.dart';

/// Result of audio transcription containing the text and metadata.
@freezed
class TranscriptionResult with _$TranscriptionResult {
  const factory TranscriptionResult({
    required String recordingId,
    required String transcribedText,
    required double confidence,
    required TranscriptionMode mode,
    required DateTime completedAt,
  }) = _TranscriptionResult;

  factory TranscriptionResult.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionResultFromJson(json);
}

/// Mode used for transcription.
enum TranscriptionMode {
  /// Online transcription using external API
  online,

  /// Offline transcription using platform speech recognition
  offline,
}
