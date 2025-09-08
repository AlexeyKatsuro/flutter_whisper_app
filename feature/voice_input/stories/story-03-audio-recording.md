# Story 03: Audio Recording Implementation

## Overview
Implement core audio recording functionality with proper file management, recording controls, and state management. This story provides the foundation for voice capture without transcription.

## Acceptance Criteria
- [ ] Audio recording starts and stops correctly
- [ ] Recording duration tracking and 60-second limit enforcement
- [ ] Proper audio file management with cleanup
- [ ] Recording state visualization and controls
- [ ] App backgrounding/foregrounding handling during recording
- [ ] Recording cancellation with proper cleanup

## Tasks Checklist

### Data Layer - Audio Recording
- [ ] Create `AudioFileDataSource` interface (`src/data/datasources/audio_file_datasource.dart`)
- [ ] Implement `AudioFileDataSourceImpl` using record package
- [ ] Add methods: `startRecording()`, `stopRecording()`, `cancelRecording()`, `cleanup()`
- [ ] Implement proper file path management and temporary file handling
- [ ] Add recording duration tracking and maximum duration enforcement (60s)

### Domain Layer - Use Cases
- [ ] Create `StartVoiceRecordingUseCase` (`src/domain/usecases/start_voice_recording_usecase.dart`)
- [ ] Create `StopVoiceRecordingUseCase` (`src/domain/usecases/stop_voice_recording_usecase.dart`)
- [ ] Create `CancelRecordingUseCase` (`src/domain/usecases/cancel_recording_usecase.dart`)
- [ ] Implement business rules (min 1s, max 60s recording duration)

### Repository Implementation
- [ ] Extend `VoiceInputRepositoryImpl` with recording methods
- [ ] Implement `startRecording()` returning Stream<VoiceRecording>
- [ ] Implement `stopRecording()` and `cancelRecording()`
- [ ] Add automatic cleanup of temporary files
- [ ] Handle app lifecycle changes during recording

### BLoC Recording Logic
- [ ] Update `VoiceInputBloc` with recording event handlers
- [ ] Implement recording state transitions (idle → recording → recorded)
- [ ] Add recording timer functionality
- [ ] Handle recording cancellation and cleanup
- [ ] Implement auto-stop at 60-second limit

### Audio File Management
- [ ] Implement secure temporary file storage
- [ ] Add automatic cleanup after 24 hours
- [ ] Handle platform-specific audio formats (AAC for iOS, AMR_WB for Android)
- [ ] Implement proper file permissions and access

### Error Handling
- [ ] Create `RecordingException` and subclasses
- [ ] Handle microphone access errors during recording
- [ ] Handle file system errors
- [ ] Implement recording interruption recovery

## Testing Verification

### Unit Tests
- [ ] Test `AudioFileDataSource` recording methods
- [ ] Test all recording use cases
- [ ] Test repository recording implementation
- [ ] Test BLoC recording state transitions
- [ ] Test duration limits and business rules

### Integration Tests
- [ ] Test actual audio recording and file creation
- [ ] Test recording cancellation and cleanup
- [ ] Test app backgrounding during recording
- [ ] Test maximum duration auto-stop
- [ ] Test file cleanup functionality

### Manual Testing
- [ ] Record audio for various durations (1s, 30s, 60s+)
- [ ] Cancel recording mid-way - verify cleanup
- [ ] Background app during recording - verify state preservation
- [ ] Test on both iOS and Android devices
- [ ] Verify audio file quality and format

## Dependencies
- Story 01: Project Setup and Foundation
- Story 02: Permission Management System

## Notes
- This story focuses on recording without transcription
- Audio quality should be optimized for speech recognition
- Implement proper resource cleanup to prevent memory leaks
- Handle platform-specific audio session management
- Recording should work offline (no network required)
