# Voice Input Platform Setup

This document describes the platform-specific setup required for the voice input feature.

## iOS Setup

### Required Permissions

Add the following entries to your `ios/Runner/Info.plist` file:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Voice input requires access to your microphone to record and transcribe your speech.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Voice input uses speech recognition to transcribe your recordings offline when network is unavailable.</string>
```

### Audio Session Configuration

The voice input feature automatically configures the audio session for recording. No additional setup is required.

### Background Audio (Optional)

If you want to allow voice recording to continue when the app goes to background, add the following to your `Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

**Note**: This requires careful handling of recording state when the app is backgrounded.

## Android Setup

### Required Permissions

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Required for audio recording -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />

<!-- Required for online transcription -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- Optional: For network state detection -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Minimum SDK Version

The voice input feature requires Android API level 21 (Android 5.0) or higher. Ensure your `android/app/build.gradle` has:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### ProGuard Configuration (Release Builds)

If you're using ProGuard for release builds, add the following rules to keep speech recognition classes:

```proguard
-keep class android.speech.** { *; }
-keep class com.google.android.gms.** { *; }
```

## Permission Handling

### Runtime Permissions

The voice input feature automatically handles runtime permission requests:

1. **Microphone Permission**: Required for audio recording
2. **Speech Recognition Permission**: Optional, enables offline transcription

### Permission States

The system tracks the following permission states:

- **Granted**: Permission is available for use
- **Denied**: Permission was denied but can be requested again
- **Permanently Denied**: Permission was denied with "Don't ask again" (Android) or equivalent (iOS)
- **Restricted**: Permission is restricted by device policy (iOS)

### Handling Permission Denial

When permissions are denied:

1. **Microphone Denied**: Voice input feature is completely disabled
2. **Speech Recognition Denied**: Only online transcription is available
3. **Permanently Denied**: User is directed to app settings to manually enable permissions

## Testing Permissions

### iOS Simulator

iOS Simulator doesn't support microphone access. Test on a physical device for full functionality.

### Android Emulator

Android Emulator supports microphone access if:
1. Your development machine has a microphone
2. The emulator is configured with audio input enabled

### Permission Reset

To test permission flows during development:

**iOS**: 
- Go to Settings > Privacy & Security > Microphone > [Your App] and toggle permissions
- Or reset all permissions: Settings > General > Reset > Reset Location & Privacy

**Android**:
- Go to Settings > Apps > [Your App] > Permissions and modify permissions
- Or use ADB: `adb shell pm reset-permissions`

## Troubleshooting

### Common Issues

1. **Microphone not working**: Check device permissions and ensure no other app is using the microphone
2. **Speech recognition fails**: Verify device language settings match expected language
3. **Permissions not requested**: Ensure platform setup is complete and app is rebuilt
4. **App crashes on permission request**: Check that permission descriptions are added to Info.plist (iOS)

### Debug Information

Enable debug logging to see permission status:

```dart
import 'package:logger/logger.dart';

final logger = Logger();
logger.d('Permission status: $permissions');
```

### Platform-Specific Debugging

**iOS**: Check Xcode console for permission-related messages and audio session errors.

**Android**: Use `adb logcat` to see permission requests and speech recognition logs:

```bash
adb logcat | grep -E "(Permission|Speech|Audio)"
```
