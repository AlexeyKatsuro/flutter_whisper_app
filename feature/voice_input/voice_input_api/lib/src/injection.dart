import 'package:logger/logger.dart';
import 'package:rest_client/rest_client.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_bloc.dart';
import 'package:voice_input_api/src/domain/model/transcription_result.dart';
import 'package:voice_input_api/src/domain/model/voice_input_permission.dart';
import 'package:voice_input_api/src/domain/model/voice_recording.dart';
import 'package:voice_input_api/src/domain/repositories/voice_input_repository.dart';

/// Container for voice input feature dependencies.
///
/// Provides dependency injection for the voice input feature,
/// including repository implementations, BLoC instances, and use cases.
class VoiceInputContainer {
  const VoiceInputContainer({
    required this.repository,
    required this.bloc,
  });

  final VoiceInputRepository repository;
  final VoiceInputBloc bloc;

  /// Creates a new [VoiceInputContainer] with all dependencies initialized.
  ///
  /// [logger] is used for logging throughout the feature.
  /// [restClient] is used for online transcription API calls.
  static Future<VoiceInputContainer> create({
    required Logger logger,
    required RestClient restClient,
  }) async {
    // Create repository with placeholder implementation
    // TODO: Replace with actual implementation in subsequent stories
    final repository = _PlaceholderVoiceInputRepository();

    // Create BLoC with repository dependency
    final bloc = VoiceInputBloc(repository: repository);

    return VoiceInputContainer(
      repository: repository,
      bloc: bloc,
    );
  }

  /// Disposes of all resources held by this container.
  Future<void> dispose() async {
    await bloc.close();
    await repository.cleanup();
  }
}

/// Placeholder implementation of [VoiceInputRepository] for Story 01.
///
/// This will be replaced with actual implementations in subsequent stories.
class _PlaceholderVoiceInputRepository implements VoiceInputRepository {
  @override
  Future<void> cancelRecording(String recordingId) async {
    throw UnimplementedError('Will be implemented in Story 03');
  }

  @override
  Future<VoiceInputPermission> checkPermissions() async {
    throw UnimplementedError('Will be implemented in Story 02');
  }

  @override
  Future<void> cleanup() async {
    // No-op for placeholder
  }

  @override
  Stream<bool> get networkConnectivity => Stream.value(false);

  @override
  Future<void> openAppSettings() async {
    throw UnimplementedError('Will be implemented in Story 02');
  }

  @override
  Future<VoiceInputPermission> requestPermissions() async {
    throw UnimplementedError('Will be implemented in Story 02');
  }

  @override
  Stream<VoiceRecording> startRecording() {
    throw UnimplementedError('Will be implemented in Story 03');
  }

  @override
  Future<VoiceRecording> stopRecording() async {
    throw UnimplementedError('Will be implemented in Story 03');
  }

  @override
  Future<TranscriptionResult> transcribeOffline(VoiceRecording recording) async {
    throw UnimplementedError('Will be implemented in Story 04');
  }

  @override
  Future<TranscriptionResult> transcribeOnline(VoiceRecording recording) async {
    throw UnimplementedError('Will be implemented in Story 05');
  }
}
