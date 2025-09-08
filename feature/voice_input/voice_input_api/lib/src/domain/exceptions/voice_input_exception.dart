/// Base exception for all voice input related errors.
abstract class VoiceInputException implements Exception {
  const VoiceInputException(this.message);

  final String message;

  @override
  String toString() => 'VoiceInputException: $message';
}

/// Exception thrown when microphone permission is denied.
class PermissionDeniedException extends VoiceInputException {
  const PermissionDeniedException() : super('Microphone permission denied');
}

/// Exception thrown when recording operations fail.
class RecordingException extends VoiceInputException {
  const RecordingException(super.message);
}

/// Exception thrown when transcription operations fail.
class TranscriptionException extends VoiceInputException {
  const TranscriptionException(super.message);
}

/// Exception thrown when network operations timeout.
class NetworkTimeoutException extends VoiceInputException {
  const NetworkTimeoutException() : super('Network timeout during transcription');
}

/// Exception thrown when audio format is not supported.
class UnsupportedAudioException extends VoiceInputException {
  const UnsupportedAudioException(String format) : super('Unsupported audio format: $format');
}

/// Exception thrown when recording is not found.
class RecordingNotFoundException extends VoiceInputException {
  const RecordingNotFoundException(String recordingId) : super('Recording not found: $recordingId');
}

/// Exception thrown when file system operations fail.
class FileSystemException extends VoiceInputException {
  const FileSystemException(super.message);
}
