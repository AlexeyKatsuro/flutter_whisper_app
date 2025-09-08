import '../repositories/voice_input_repository.dart';

/// Use case for opening app settings for permission management.
class OpenAppSettingsUseCase {
  const OpenAppSettingsUseCase(this._repository);

  final VoiceInputRepository _repository;

  /// Opens the device's app settings screen where users can manage permissions.
  ///
  /// This is typically used when permissions have been permanently denied
  /// and need to be enabled manually by the user.
  Future<void> call() async {
    await _repository.openAppSettings();
  }
}
