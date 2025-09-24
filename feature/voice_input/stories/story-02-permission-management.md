# Story 02: Permission Management System

## Overview
Implement comprehensive permission management for microphone and speech recognition access. This story handles all permission-related functionality including checking, requesting, and managing permission states.

## Acceptance Criteria
- [x] Microphone permission checking and requesting works on both iOS and Android
- [x] Speech recognition permission handling implemented
- [x] Permission states are properly tracked and managed
- [x] Graceful handling of permission denial scenarios
- [x] App settings navigation for permission management
- [x] Permission status caching implemented

## Tasks Checklist

### Data Layer - Permission Data Source
- [x] Create `PermissionDataSource` interface (`src/data/datasources/permission_datasource.dart`)
- [x] Implement `PermissionDataSourceImpl` using permission_handler package
- [x] Add methods: `checkPermissions()`, `requestPermissions()`, `openAppSettings()`
- [x] Implement permission status caching (5-minute TTL)
- [x] Handle platform-specific permission differences (iOS/Android)

### Domain Layer - Use Cases
- [x] Create `CheckPermissionsUseCase` (`src/domain/usecases/check_permissions_usecase.dart`)
- [x] Create `RequestPermissionsUseCase` (`src/domain/usecases/request_permissions_usecase.dart`)
- [x] Create `OpenAppSettingsUseCase` (`src/domain/usecases/open_app_settings_usecase.dart`)
- [x] Add proper error handling for permission exceptions

### Repository Implementation
- [x] Create `VoiceInputRepositoryImpl` partial implementation (`src/data/repositories/voice_input_repository_impl.dart`)
- [x] Implement permission-related methods only
- [x] Add proper error mapping from platform exceptions
- [x] Implement caching strategy for permission status

### BLoC Integration
- [x] Update `VoiceInputBloc` to handle permission events
- [x] Implement permission checking on initialization
- [x] Add permission request flow handling
- [x] Handle permission denial and settings navigation

### Platform Configuration
- [x] Add iOS permission descriptions to Info.plist template/documentation
- [x] Add Android permission declarations to AndroidManifest.xml template/documentation
- [x] Document required permission setup for integration

### Error Handling
- [x] Implement `PermissionDeniedException`
- [x] Add proper error states in BLoC
- [x] Handle edge cases (permissions revoked while app running)

## Testing Verification

### Unit Tests
- [x] Test `PermissionDataSource` with mocked permission_handler
- [x] Test all permission use cases with various scenarios
- [x] Test repository permission methods
- [x] Test BLoC permission event handling

### Integration Tests
- [ ] Test actual permission request flow
- [ ] Verify permission caching behavior
- [ ] Test app settings navigation
- [ ] Test permission denial scenarios

### Manual Testing
- [ ] Grant permissions - verify success flow
- [ ] Deny permissions - verify error handling and settings navigation
- [ ] Revoke permissions while app running - verify proper state updates
- [ ] Test on both iOS and Android devices

## Dependencies
- Story 01: Project Setup and Foundation

## Notes
- This story focuses purely on permission management
- No audio recording functionality yet
- Use permission_handler package for cross-platform support
- Implement proper caching to avoid excessive system calls
- Document platform-specific setup requirements
