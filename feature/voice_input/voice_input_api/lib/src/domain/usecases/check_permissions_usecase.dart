import '../model/voice_input_permission.dart';
import '../repositories/voice_input_repository.dart';

/// Use case for checking voice input permissions.
class CheckPermissionsUseCase {
  const CheckPermissionsUseCase(this._repository);

  final VoiceInputRepository _repository;

  /// Checks the current permission status for voice input functionality.
  ///
  /// Returns [VoiceInputPermission] with current permission states.
  /// This operation uses caching to avoid excessive system calls.
  Future<VoiceInputPermission> call() async {
    return _repository.checkPermissions();
  }
}
