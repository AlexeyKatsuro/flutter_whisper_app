import 'package:permission_handler/permission_handler.dart' as permission_handler;

import '../../domain/model/voice_input_permission.dart';

/// Data source for managing voice input permissions.
abstract interface class PermissionDataSource {
  /// Checks the current status of all required permissions.
  Future<VoiceInputPermission> checkPermissions();

  /// Requests the required permissions from the user.
  Future<VoiceInputPermission> requestPermissions();

  /// Opens the app settings for permission management.
  Future<void> openAppSettings();

  /// Gets the cached permission status if available.
  VoiceInputPermission? getCachedPermissions();

  /// Caches the permission status for future use.
  void cachePermissions(VoiceInputPermission permissions);

  /// Clears the cached permission status.
  void clearPermissionCache();
}

/// Implementation of PermissionDataSource using permission_handler package.
class PermissionDataSourceImpl implements PermissionDataSource {
  PermissionDataSourceImpl({
    this.cacheTimeoutDuration = const Duration(minutes: 5),
  });

  final Duration cacheTimeoutDuration;
  VoiceInputPermission? _cachedPermissions;
  DateTime? _cacheTimestamp;

  @override
  Future<VoiceInputPermission> checkPermissions() async {
    // Check if we have valid cached permissions
    final cached = getCachedPermissions();
    if (cached != null) {
      return cached;
    }

    // Check actual permissions from system
    final microphoneStatus = await permission_handler.Permission.microphone.status;
    final speechStatus = await permission_handler.Permission.speech.status;

    final permissions = VoiceInputPermission(
      microphoneGranted: microphoneStatus.isGranted,
      speechRecognitionGranted: speechStatus.isGranted,
      canRequestMicrophone: _canRequestPermission(microphoneStatus),
      canRequestSpeechRecognition: _canRequestPermission(speechStatus),
    );

    // Cache the result
    cachePermissions(permissions);

    return permissions;
  }

  @override
  Future<VoiceInputPermission> requestPermissions() async {
    // Clear cache before requesting new permissions
    clearPermissionCache();

    // Request microphone permission first (required)
    final microphoneStatus = await permission_handler.Permission.microphone.request();

    // Request speech recognition permission (optional, for offline transcription)
    final speechStatus = await permission_handler.Permission.speech.request();

    final permissions = VoiceInputPermission(
      microphoneGranted: microphoneStatus.isGranted,
      speechRecognitionGranted: speechStatus.isGranted,
      canRequestMicrophone: _canRequestPermission(microphoneStatus),
      canRequestSpeechRecognition: _canRequestPermission(speechStatus),
    );

    // Cache the new permissions
    cachePermissions(permissions);

    return permissions;
  }

  @override
  Future<void> openAppSettings() async {
    await permission_handler.openAppSettings();
  }

  @override
  VoiceInputPermission? getCachedPermissions() {
    if (_cachedPermissions == null || _cacheTimestamp == null) {
      return null;
    }

    final now = DateTime.now();
    if (now.difference(_cacheTimestamp!) > cacheTimeoutDuration) {
      // Cache expired
      clearPermissionCache();
      return null;
    }

    return _cachedPermissions;
  }

  @override
  void cachePermissions(VoiceInputPermission permissions) {
    _cachedPermissions = permissions;
    _cacheTimestamp = DateTime.now();
  }

  @override
  void clearPermissionCache() {
    _cachedPermissions = null;
    _cacheTimestamp = null;
  }

  /// Determines if a permission can still be requested based on its status.
  bool _canRequestPermission(permission_handler.PermissionStatus status) {
    switch (status) {
      case permission_handler.PermissionStatus.denied:
      case permission_handler.PermissionStatus.restricted:
        return true;
      case permission_handler.PermissionStatus.granted:
      case permission_handler.PermissionStatus.limited:
        return false;
      case permission_handler.PermissionStatus.permanentlyDenied:
        return false;
      case permission_handler.PermissionStatus.provisional:
        return true;
    }
  }
}
