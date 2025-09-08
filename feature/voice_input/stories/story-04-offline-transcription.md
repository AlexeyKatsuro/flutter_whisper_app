# Story 04: Offline Transcription Implementation

## Overview
Implement offline speech-to-text transcription using platform-native speech recognition services. This provides the fallback transcription method and works without internet connectivity.

## Acceptance Criteria
- [ ] Platform speech recognition integration (iOS Speech framework, Android SpeechRecognizer)
- [ ] Offline transcription of recorded audio files
- [ ] Confidence scoring and language detection
- [ ] Proper error handling for unsupported audio formats
- [ ] Graceful degradation when offline transcription unavailable
- [ ] Performance optimization for local processing

## Tasks Checklist

### Data Layer - Speech Recognition
- [ ] Create `SpeechRecognitionDataSource` interface (`src/data/datasources/speech_recognition_datasource.dart`)
- [ ] Implement `SpeechRecognitionDataSourceImpl` using speech_to_text package
- [ ] Add method: `transcribeOffline(VoiceRecording recording)`
- [ ] Handle platform-specific speech recognition setup
- [ ] Implement proper audio file format handling

### Domain Layer - Use Cases
- [ ] Create `TranscribeOfflineUseCase` (`src/domain/usecases/transcribe_offline_usecase.dart`)
- [ ] Implement business logic for offline transcription
- [ ] Add validation for audio file format and duration
- [ ] Handle unsupported device scenarios

### Repository Implementation
- [ ] Extend `VoiceInputRepositoryImpl` with `transcribeOffline()` method
- [ ] Implement proper error mapping from platform exceptions
- [ ] Add audio file format conversion if needed
- [ ] Handle speech recognition service availability

### BLoC Transcription Logic
- [ ] Update `VoiceInputBloc` with offline transcription handling
- [ ] Implement processing state transitions (recorded → processing → success/error)
- [ ] Add transcription mode indication (offline)
- [ ] Handle transcription failures and retry logic

### Audio Processing
- [ ] Implement audio file format validation
- [ ] Add audio preprocessing if required by platform
- [ ] Handle sample rate and encoding requirements
- [ ] Optimize audio for speech recognition accuracy

### Error Handling
- [ ] Create `OfflineTranscriptionException` and subclasses
- [ ] Handle unsupported audio format errors
- [ ] Handle speech recognition service unavailable
- [ ] Handle empty/unclear audio scenarios

### Performance Optimization
- [ ] Implement efficient audio file handling
- [ ] Add progress indication for long transcriptions
- [ ] Optimize memory usage during processing
- [ ] Handle large audio files gracefully

## Testing Verification

### Unit Tests
- [ ] Test `SpeechRecognitionDataSource` with various audio inputs
- [ ] Test `TranscribeOfflineUseCase` business logic
- [ ] Test repository offline transcription method
- [ ] Test BLoC offline transcription flow
- [ ] Test error scenarios and edge cases

### Integration Tests
- [ ] Test actual offline transcription with real audio files
- [ ] Test with various audio qualities and durations
- [ ] Test unsupported format handling
- [ ] Test on devices without speech recognition support
- [ ] Test performance with different audio lengths

### Manual Testing
- [ ] Record and transcribe speech in various languages
- [ ] Test with clear and unclear audio
- [ ] Test with background noise
- [ ] Verify transcription accuracy and confidence scores
- [ ] Test offline functionality (airplane mode)
- [ ] Test on both iOS and Android devices

## Dependencies
- Story 01: Project Setup and Foundation
- Story 02: Permission Management System  
- Story 03: Audio Recording Implementation

## Notes
- This story provides offline-first transcription capability
- Platform speech recognition may have language limitations
- Confidence scores help assess transcription quality
- Some devices may not support offline speech recognition
- Consider audio preprocessing to improve accuracy
