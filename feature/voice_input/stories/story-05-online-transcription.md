# Story 05: Online Transcription Service

## Overview
Implement online transcription service integration with REST API, including network connectivity detection, request/response handling, and automatic fallback to offline transcription.

## Acceptance Criteria
- [ ] REST API integration for online transcription service
- [ ] Network connectivity monitoring and detection
- [ ] Audio file upload with base64 encoding
- [ ] Automatic fallback to offline transcription on network failure
- [ ] Request timeout and retry mechanisms
- [ ] Higher transcription accuracy compared to offline mode

## Tasks Checklist

### Data Layer - API Integration
- [ ] Create `TranscriptionApiDataSource` interface (`src/data/datasources/transcription_api_datasource.dart`)
- [ ] Implement `TranscriptionApiDataSourceImpl` using rest_client
- [ ] Create DTOs: `TranscriptionRequestDto` and `TranscriptionResponseDto` with Freezed
- [ ] Implement base64 audio encoding for API requests
- [ ] Add proper error handling for HTTP responses (4xx, 5xx)

### Data Layer - Network Monitoring
- [ ] Create `NetworkConnectivityDataSource` interface (`src/data/datasources/network_connectivity_datasource.dart`)
- [ ] Implement network connectivity monitoring with Stream<bool>
- [ ] Add connectivity change detection
- [ ] Handle network state caching

### Domain Layer - Use Cases
- [ ] Create `TranscribeOnlineUseCase` (`src/domain/usecases/transcribe_online_usecase.dart`)
- [ ] Create `TranscribeAudioUseCase` with online/offline fallback logic (`src/domain/usecases/transcribe_audio_usecase.dart`)
- [ ] Implement automatic fallback strategy (online → offline)
- [ ] Add retry mechanisms with exponential backoff

### Repository Implementation
- [ ] Extend `VoiceInputRepositoryImpl` with `transcribeOnline()` method
- [ ] Implement `networkConnectivity` stream
- [ ] Add automatic fallback logic in `transcribeAudio()`
- [ ] Handle network timeout and retry scenarios

### BLoC Online Logic
- [ ] Update `VoiceInputBloc` with online transcription handling
- [ ] Implement network connectivity awareness
- [ ] Add transcription mode indication (online/offline)
- [ ] Handle automatic fallback scenarios with user notification

### API Client Configuration
- [ ] Configure request timeouts (30 seconds)
- [ ] Implement proper error mapping for API responses
- [ ] Add rate limiting handling (429 responses)
- [ ] Set up audio compression for efficient uploads

### Error Handling
- [ ] Create `OnlineTranscriptionException` and subclasses
- [ ] Handle network timeout scenarios
- [ ] Handle API rate limiting and server errors
- [ ] Implement graceful degradation to offline mode

## Testing Verification

### Unit Tests
- [ ] Test `TranscriptionApiDataSource` with mock HTTP responses
- [ ] Test `NetworkConnectivityDataSource` connectivity monitoring
- [ ] Test online transcription use cases
- [ ] Test fallback logic in `TranscribeAudioUseCase`
- [ ] Test BLoC online transcription flow

### Integration Tests
- [ ] Test actual API integration with mock server
- [ ] Test network connectivity changes during transcription
- [ ] Test automatic fallback scenarios
- [ ] Test retry mechanisms with network failures
- [ ] Test audio upload and response parsing

### Manual Testing
- [ ] Test online transcription with good network connectivity
- [ ] Test fallback to offline when network unavailable
- [ ] Test during network connectivity changes
- [ ] Compare transcription accuracy: online vs offline
- [ ] Test with various audio qualities and languages
- [ ] Test API error scenarios (server down, rate limiting)

## Dependencies
- Story 01: Project Setup and Foundation
- Story 02: Permission Management System
- Story 03: Audio Recording Implementation
- Story 04: Offline Transcription Implementation

## Notes
- Online transcription should provide higher accuracy than offline
- Implement smart fallback: try online first, fallback to offline
- Network monitoring should be real-time for immediate fallback
- Consider audio compression to reduce upload time and data usage
- Handle API authentication if required in future versions
