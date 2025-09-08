# Voice Input Feature - Technical Specification

## 1. Architecture Overview

### Feature Module Structure
- **Package Name**: `feature/voice_input/voice_input_api`
- **Module Dependencies**: 
  - `core/common` - Utilities and extensions
  - `core/logger` - Logging infrastructure  
  - `core/error_reporter` - Error reporting
  - `core/rest_client` - HTTP client for transcription API
  - `core/ui_library` - Shared UI components and MD3 tokens
- **Public API**: Voice input widget component and transcription service
- **Integration Points**: Main screen text input field, app permission system, network connectivity monitoring

### Clean Architecture Layers
- **Domain Layer**: Voice recording entity, transcription use cases, audio repository contract
- **Data Layer**: Audio file data source, transcription API client, platform speech recognition
- **Application Layer**: Voice input BLoC with recording/transcription state management
- **Presentation Layer**: Voice input widget, recording UI components, permission dialogs

## 2. Technical Implementation

### Domain Models

```dart
@freezed
class VoiceRecording with _$VoiceRecording {
  const factory VoiceRecording({
    required String id,
    required String filePath,
    required Duration duration,
    required DateTime createdAt,
    required VoiceRecordingStatus status,
  }) = _VoiceRecording;
}

enum VoiceRecordingStatus {
  recording,
  recorded,
  processing,
  transcribed,
  failed,
}

@freezed
class TranscriptionResult with _$TranscriptionResult {
  const factory TranscriptionResult({
    required String recordingId,
    required String transcribedText,
    required double confidence,
    required TranscriptionMode mode,
    required DateTime completedAt,
  }) = _TranscriptionResult;
}

enum TranscriptionMode {
  online,
  offline,
}

@freezed
class VoiceInputPermission with _$VoiceInputPermission {
  const factory VoiceInputPermission({
    required bool microphoneGranted,
    required bool speechRecognitionGranted,
    required bool canRequestMicrophone,
    required bool canRequestSpeechRecognition,
  }) = _VoiceInputPermission;
}
```

### Repository Contracts

```dart
abstract interface class VoiceInputRepository {
  Future<VoiceInputPermission> checkPermissions();
  Future<VoiceInputPermission> requestPermissions();
  Future<void> openAppSettings();
  
  Stream<VoiceRecording> startRecording();
  Future<VoiceRecording> stopRecording();
  Future<void> cancelRecording(String recordingId);
  
  Future<TranscriptionResult> transcribeOnline(VoiceRecording recording);
  Future<TranscriptionResult> transcribeOffline(VoiceRecording recording);
  
  Stream<bool> get networkConnectivity;
  Future<void> cleanup();
}
```

### Use Cases/Business Logic

**StartVoiceRecording Use Case:**
- Purpose: Initiate voice recording with permission checks
- Inputs: None
- Outputs: Stream<VoiceRecording>
- Exceptions: PermissionDeniedException, RecordingException

**StopVoiceRecording Use Case:**
- Purpose: Stop recording and prepare for transcription
- Inputs: recordingId
- Outputs: VoiceRecording
- Exceptions: RecordingNotFoundException, FileSystemException

**TranscribeAudio Use Case:**
- Purpose: Convert audio to text with online/offline fallback
- Inputs: VoiceRecording, preferOnline
- Outputs: TranscriptionResult
- Exceptions: TranscriptionException, NetworkException, UnsupportedAudioException

**Business Constraints:**
- Maximum recording duration: 60 seconds
- Minimum recording duration: 1 second
- Supported audio formats: AAC (iOS), AMR_WB (Android)
- Auto-cleanup of temporary files after 24 hours

### State Management (BLoC Pattern)

```dart
@freezed
sealed class VoiceInputEvent with _$VoiceInputEvent {
  const factory VoiceInputEvent.permissionRequested() = _PermissionRequested;
  const factory VoiceInputEvent.recordingStarted() = _RecordingStarted;
  const factory VoiceInputEvent.recordingStopped() = _RecordingStopped;
  const factory VoiceInputEvent.recordingCancelled() = _RecordingCancelled;
  const factory VoiceInputEvent.transcriptionRequested({
    required VoiceRecording recording,
    required bool preferOnline,
  }) = _TranscriptionRequested;
  const factory VoiceInputEvent.transcriptionRetried() = _TranscriptionRetried;
  const factory VoiceInputEvent.errorDismissed() = _ErrorDismissed;
  const factory VoiceInputEvent.settingsOpened() = _SettingsOpened;
}

@freezed
sealed class VoiceInputState with _$VoiceInputState {
  const factory VoiceInputState.idle({
    required VoiceInputPermission permission,
    required bool isOnline,
  }) = _Idle;
  
  const factory VoiceInputState.permissionRequesting() = _PermissionRequesting;
  
  const factory VoiceInputState.permissionDenied({
    required VoiceInputPermission permission,
  }) = _PermissionDenied;
  
  const factory VoiceInputState.recording({
    required VoiceRecording recording,
    required bool isOnline,
  }) = _Recording;
  
  const factory VoiceInputState.processing({
    required VoiceRecording recording,
    required TranscriptionMode mode,
  }) = _Processing;
  
  const factory VoiceInputState.success({
    required TranscriptionResult result,
    required bool isOnline,
  }) = _Success;
  
  const factory VoiceInputState.error({
    required VoiceInputError error,
    required bool canRetry,
    VoiceRecording? recording,
  }) = _Error;
}
```

## 3. Data Layer Implementation

### Data Sources

**Local Data Sources:**
- `AudioFileDataSource`: File system operations for audio storage
- `PermissionDataSource`: Platform permission management
- `PreferencesDataSource`: User settings for voice input preferences

**Remote Data Sources:**
- `TranscriptionApiDataSource`: REST API for online transcription
- `NetworkConnectivityDataSource`: Network status monitoring

**Platform Services:**
- `AudioRecorderService`: Native audio recording (iOS: AVAudioRecorder, Android: MediaRecorder)
- `SpeechRecognitionService`: Platform speech recognition (iOS: Speech framework, Android: SpeechRecognizer)
- `PermissionService`: Permission handling (permission_handler package)

### Data Transfer Objects (DTOs)

```dart
@freezed
class TranscriptionRequestDto with _$TranscriptionRequestDto {
  const factory TranscriptionRequestDto({
    required String audioBase64,
    required String format,
    required String language,
    required int sampleRate,
  }) = _TranscriptionRequestDto;
  
  factory TranscriptionRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionRequestDtoFromJson(json);
}

@freezed
class TranscriptionResponseDto with _$TranscriptionResponseDto {
  const factory TranscriptionResponseDto({
    required String text,
    required double confidence,
    required String language,
    String? error,
  }) = _TranscriptionResponseDto;
  
  factory TranscriptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionResponseDtoFromJson(json);
}
```

### Repository Implementation

**Caching Strategy:**
- No caching of audio files (immediate cleanup after transcription)
- Cache permission status for 5 minutes to avoid repeated system calls
- Cache network connectivity status with real-time updates

**Offline Support:**
- Automatic fallback to platform speech recognition when online API fails
- Queue transcription requests when network is unavailable
- Local audio file preservation during network issues

**Error Mapping:**
- HTTP 4xx errors → TranscriptionValidationException
- HTTP 5xx errors → TranscriptionServiceException  
- Network timeouts → NetworkTimeoutException
- Platform errors → PlatformException

## 4. Platform Integration

### Permissions

**Required Permissions:**
- **iOS**: NSMicrophoneUsageDescription, NSSpeechRecognitionUsageDescription
- **Android**: RECORD_AUDIO, INTERNET

**Permission Flow:**
1. Check current permission status on feature initialization
2. Request microphone permission on first recording attempt
3. Request speech recognition permission for offline transcription

**Permission Handling:**
- Microphone denied: Show settings redirect with explanation
- Speech recognition denied: Disable offline mode, online-only operation
- Both denied: Feature completely disabled with manual input fallback

### Native Platform Features

**iOS Implementation:**
- Use AVAudioRecorder with AVAudioSession configuration
- Speech framework for offline transcription
- Background audio session handling during app state changes
- Audio interruption handling (calls, other apps)

**Android Implementation:**
- MediaRecorder with proper audio source configuration
- SpeechRecognizer with custom RecognitionListener
- Audio focus management for recording
- Handle audio recording during phone calls

**Platform Channels:**
No custom platform channels needed - using existing Flutter packages:
- `record` package for audio recording
- `speech_to_text` package for offline transcription
- `permission_handler` for permission management

### Third-party Services

**External APIs:**
- Transcription service: REST API with OAuth2 authentication
- Endpoint: POST /v1/transcribe
- No Authentication needed
- Rate limiting: 100 requests/minute per API key

**SDK Integration:**
- No additional SDKs required
- Using Flutter packages for platform features

**Fallback Mechanisms:**
- API unavailable: Automatic offline transcription
- API rate limited: Show user message and retry after delay
- Authentication failed: Log error and fallback to offline

#### OpenAPI Specification (Transcription Service)

```yaml
openapi: 3.0.3
info:
  title: Voice Transcription API
  version: 1.0.0
paths:
  /v1/transcribe:
    post:
      summary: Transcribe audio to text
      operationId: transcribeAudio
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [audioBase64, format, language, sampleRate]
              properties:
                audioBase64:
                  type: string
                  description: Base64-encoded audio content
                format:
                  type: string
                  enum: [aac, amr_wb]
                language:
                  type: string
                  example: en-US
                sampleRate:
                  type: integer
                  format: int32
                  example: 16000
      responses:
        '200':
          description: Successful transcription
          content:
            application/json:
              schema:
                type: object
                required: [text, confidence, language]
                properties:
                  text:
                    type: string
                  confidence:
                    type: number
                    format: float
                  language:
                    type: string
        '400':
          description: Validation error
        '429':
          description: Rate limit exceeded
        '500':
          description: Server error
      security: []
```

## 5. Dependency Injection

### Feature Container

```dart
class VoiceInputContainer {
  const VoiceInputContainer({
    required this.repository,
    required this.bloc,
    required this.startRecordingUseCase,
    required this.stopRecordingUseCase,
    required this.transcribeAudioUseCase,
  });
  
  final VoiceInputRepository repository;
  final VoiceInputBloc bloc;
  final StartVoiceRecordingUseCase startRecordingUseCase;
  final StopVoiceRecordingUseCase stopRecordingUseCase;
  final TranscribeAudioUseCase transcribeAudioUseCase;
  
  static Future<VoiceInputContainer> create(Dependencies deps) async {
    final repository = VoiceInputRepositoryImpl(
      audioFileDataSource: AudioFileDataSource(),
      transcriptionApiDataSource: TranscriptionApiDataSource(deps.restClient),
      speechRecognitionDataSource: SpeechRecognitionDataSource(),
      permissionDataSource: PermissionDataSource(),
      networkDataSource: NetworkConnectivityDataSource(),
      logger: deps.logger,
    );
    
    final startRecordingUseCase = StartVoiceRecordingUseCase(repository);
    final stopRecordingUseCase = StopVoiceRecordingUseCase(repository);
    final transcribeAudioUseCase = TranscribeAudioUseCase(repository);
    
    final bloc = VoiceInputBloc(
      startRecordingUseCase: startRecordingUseCase,
      stopRecordingUseCase: stopRecordingUseCase,
      transcribeAudioUseCase: transcribeAudioUseCase,
    );
    
    return VoiceInputContainer(
      repository: repository,
      bloc: bloc,
      startRecordingUseCase: startRecordingUseCase,
      stopRecordingUseCase: stopRecordingUseCase,
      transcribeAudioUseCase: transcribeAudioUseCase,
    );
  }
  
  Future<void> dispose() async {
    await bloc.close();
    await repository.cleanup();
  }
}
```

### Dependency Graph

**Internal Dependencies:**
- VoiceInputBloc → Use Cases → Repository → Data Sources
- Use Cases are independent and can be created in parallel
- Data Sources have no internal dependencies

**External Dependencies:**
- `core/rest_client` for API communication
- `core/logger` for logging and debugging
- `core/error_reporter` for crash reporting
- Platform permission services

**Initialization Order:**
1. Data sources (no dependencies)
2. Repository (depends on data sources)
3. Use cases (depend on repository)
4. BLoC (depends on use cases)

**Cleanup:**
- Dispose BLoC streams and subscriptions
- Cancel ongoing recordings and delete temporary files
- Close network connections and API clients

## 6. UI Implementation Details

### Widget Architecture

**Screen Widgets:**
- No dedicated screens - integrates into existing text input areas
- `VoiceInputField` - Main widget wrapping text field with voice input capability

**Component Widgets:**
- `VoiceInputButton` - Microphone button with state-based icons
- `VoiceRecordingIndicator` - Animated recording visualization
- `VoiceInputTimer` - Recording duration display

**State Connection:**
- Widgets obtain state via a feature scope accessor (per `bloc_patterns.mdc`).

**Navigation:**
- No navigation required - inline component
- Permission settings: Open app settings via platform API

### Material Design 3 Implementation

**Theme Integration:**
- Use `ColorScheme.primary` for active recording state
- Use `ColorScheme.error` for error states and cancel actions
- Use `ColorScheme.onSurfaceVariant` for inactive states
- Use `TextTheme.bodyLarge` for transcribed text
- Use `TextTheme.labelMedium` for timer display

**Custom Components:**
- `AnimatedSoundWaves` - Custom painter using `ColorScheme.primaryContainer`
- `PermissionBadgeIcon` - Overlay icon for permission status
- `OfflineBadgeIcon` - Overlay icon for offline status
- All components follow MD3 touch target sizes (minimum 48dp)

**Responsive Design:**
- Adaptive text field sizing based on screen width
- Responsive button spacing in recording state
- Proper keyboard avoidance during recording

**Accessibility:**
- Semantic labels for all interactive elements
- Screen reader announcements for state changes
- High contrast support for visual indicators
- Keyboard navigation support where applicable

### Animation and Transitions

**State Animations:**
- Microphone to recording icons: 200ms scale and rotate transition
- Sound waves: Continuous amplitude-based animation during recording
- Loading spinner: Standard Material loading animation
- Error state: Shake animation for error indication

**Micro-interactions:**
- Button press: Material ripple effect
- Long press: Tooltip appearance with fade-in
- Recording start: Haptic feedback and icon transition
- Success: Subtle scale animation on text appearance

**Page Transitions:**
- No page transitions - inline component
- Permission settings: Platform-standard app settings transition

## 7. Testing Strategy

### Unit Tests

**Domain Logic:**
- Use case validation and error handling
- Business rule enforcement (max duration, file formats)
- State transition logic in BLoC
- Permission status mapping and validation

**Repository Tests:**
- Mock all data sources for isolated testing
- Test online/offline fallback scenarios
- Error propagation and transformation
- Caching behavior and cleanup

**BLoC Tests:**
- All event-to-state transitions
- Error state handling and recovery
- Stream subscription management
- Bloc disposal and resource cleanup

**Widget Tests:**
- UI state rendering for all BLoC states
- User interaction handling (tap, long press)
- Animation state verification
- Accessibility testing

### Integration Tests

**Feature Flow:**
- Complete voice input flow from permission to transcription
- Error scenarios with automatic recovery
- Network connectivity changes during recording
- App lifecycle changes during recording

**Platform Integration:**
- Actual audio recording and file operations
- Real permission system integration
- Native speech recognition testing
- Network API integration

**API Integration:**
- Mock server responses for API testing
- Error response handling
- Rate limiting
- Network timeout scenarios

### Test Infrastructure

**Mock Dependencies:**
```dart
class TestVoiceInputContainer extends VoiceInputContainer {
  TestVoiceInputContainer({
    VoiceInputRepository? repository,
    VoiceInputBloc? bloc,
  }) : super(
    repository: repository ?? MockVoiceInputRepository(),
    bloc: bloc ?? MockVoiceInputBloc(),
    startRecordingUseCase: MockStartRecordingUseCase(),
    stopRecordingUseCase: MockStopRecordingUseCase(),
    transcribeAudioUseCase: MockTranscribeAudioUseCase(),
  );
}
```

**Test Utilities:**
- Audio file generators for testing
- Mock API server for integration tests
- Permission state builders for various scenarios
- BLoC state builders and matchers

<!-- Skip it for now -->
<!-- **CI/CD Integration:**
- Unit tests run on every PR
- Integration tests run on merge to main
- Platform-specific tests on iOS/Android simulators
- API integration tests with staging environment -->

## 8. Performance Considerations

### Memory Management

**Resource Cleanup:**
- Automatic disposal of audio recording streams
- Temporary file cleanup after transcription
- BLoC stream subscription disposal
- Network connection closure

**Memory Optimization:**
- Stream audio data without full file buffering
- Compress audio files before API upload
- Limit concurrent recording sessions to 1
- Periodic cleanup of old temporary files

**Memory Monitoring:**
- Track audio file sizes and cleanup status
- Monitor stream subscription count
- Alert on memory leaks during development

### Performance Optimization

**Loading Performance:**
- Permission check caching (5-minute TTL)
- Lazy initialization of speech recognition services
- Background preparation of recording services
- Async initialization with loading states

**UI Performance:**
- Debounced animation updates during recording
- Efficient widget rebuilds using BlocBuilder
- Cached icon assets for state transitions
- Minimal widget tree depth

**Network Performance:**
- Audio compression before upload (AAC/AMR)
- Request timeout configuration (30 seconds)
- Retry with exponential backoff
- Connection pooling through rest_client

**Battery Optimization:**
- Stop background processing when not recording
- Efficient audio encoding settings
- Minimal network requests
- Proper audio session management

## 9. Error Handling & Monitoring

### Exception Hierarchy

```dart
abstract class VoiceInputException implements Exception {
  const VoiceInputException(this.message);
  final String message;
}

class PermissionDeniedException extends VoiceInputException {
  const PermissionDeniedException() : super('Microphone permission denied');
}

class RecordingException extends VoiceInputException {
  const RecordingException(super.message);
}

class TranscriptionException extends VoiceInputException {
  const TranscriptionException(super.message);
}

class NetworkTimeoutException extends VoiceInputException {
  const NetworkTimeoutException() : super('Network timeout during transcription');
}

class UnsupportedAudioException extends VoiceInputException {
  const UnsupportedAudioException(String format) : super('Unsupported audio format: $format');
}
```

### Error Recovery

**Retry Mechanisms:**
- Automatic retry for network failures (3 attempts with exponential backoff)
- Manual retry button for user-initiated retry
- Fallback to offline transcription on API failures
- Resume recording after app backgrounding

**Fallback Behavior:**
- Online API failure → Offline transcription
- Offline transcription failure → Manual text input option
- Permission denied → Settings redirect with explanation
- Recording interrupted → Save partial recording and allow continuation

**User Communication:**
- Clear error messages with actionable instructions
- Toast notifications for non-critical errors
- SnackBar with retry actions for recoverable errors
- Permission explanation dialogs with settings link

### Logging and Analytics

**Event Tracking:**
- Voice input feature usage frequency
- Recording duration distribution
- Transcription accuracy metrics
- Error occurrence rates by type
- Network vs offline usage patterns

**Error Logging:**
- Detailed error context and stack traces
- User action sequence leading to errors
- Device and platform information
- Network connectivity status during errors

**Performance Metrics:**
- Recording start latency (target: <500ms)
- Transcription response times (online: <10s, offline: <5s)
- Audio processing duration
- Memory usage during recording sessions
- Battery consumption impact