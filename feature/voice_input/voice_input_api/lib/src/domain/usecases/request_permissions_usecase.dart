import '../exceptions/voice_input_exception.dart';
import '../model/voice_input_permission.dart';
import '../repositories/voice_input_repository.dart';

/// Use case for requesting voice input permissions from the user.
class RequestPermissionsUseCase {
  const RequestPermissionsUseCase(this._repository);

  final VoiceInputRepository _repository;

  /// Requests necessary permissions for voice input functionality.
  ///
  /// Returns [VoiceInputPermission] with updated permission states.
  /// Throws [PermissionDeniedException] if critical permissions are denied.
  Future<VoiceInputPermission> call() async {
    final permissions = await _repository.requestPermissions();

    // Check if microphone permission was denied (critical for voice input)
    if (!permissions.microphoneGranted && !permissions.canRequestMicrophone) {
      throw const PermissionDeniedException();
    }

    return permissions;
  }
}
