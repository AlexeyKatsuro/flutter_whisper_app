import 'package:voice_input_api/src/domain/model/transcription_result.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';

/// Repository interface for voice input functionality.
///
/// Defines contracts for permission management, audio recording,
/// transcription services, and network connectivity monitoring.
abstract interface class VoiceInputRepository {
  // Permission Management

  /// Checks current permission status for microphone and speech recognition.
  Future<VoiceInputPermission> checkPermissions();

  /// Requests necessary permissions for voice input functionality.
  Future<VoiceInputPermission> requestPermissions();

  /// Opens the app settings page for permission management.
  Future<void> openAppSettings();

  // Audio Recording

  /// Starts audio recording and returns a stream of recording updates.
  ///
  /// The stream emits [VoiceRecording] objects with updated status and duration.
  /// Throws [PermissionDeniedException] if microphone permission is denied.
  /// Throws [RecordingException] if recording fails to start.
  Stream<VoiceRecording> startRecording();

  /// Stops the current audio recording and returns the final recording.
  ///
  /// Throws [RecordingNotFoundException] if no active recording exists.
  /// Throws [FileSystemException] if audio file cannot be saved.
  Future<VoiceRecording> stopRecording();

  /// Cancels the current recording and cleans up resources.
  ///
  /// Throws [RecordingNotFoundException] if no active recording exists.
  Future<void> cancelRecording(String recordingId);

  // Transcription Services

  /// Transcribes audio using online API service.
  ///
  /// Throws [TranscriptionException] if transcription fails.
  /// Throws [NetworkTimeoutException] if network request times out.
  /// Throws [UnsupportedAudioException] if audio format is not supported.
  Future<TranscriptionResult> transcribeOnline(VoiceRecording recording);

  /// Transcribes audio using offline platform speech recognition.
  ///
  /// Throws [TranscriptionException] if transcription fails.
  /// Throws [UnsupportedAudioException] if audio format is not supported.
  Future<TranscriptionResult> transcribeOffline(VoiceRecording recording);

  // Network Connectivity

  /// Stream that emits network connectivity status changes.
  ///
  /// Emits `true` when online, `false` when offline.
  Stream<bool> get networkConnectivity;

  // Resource Management

  /// Cleans up temporary files and releases resources.
  Future<void> cleanup();
}
