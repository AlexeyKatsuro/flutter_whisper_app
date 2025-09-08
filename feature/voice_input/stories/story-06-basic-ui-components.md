# Story 06: Basic UI Components Implementation

## Overview
Implement the core UI components for voice input functionality including the microphone button, recording indicators, and basic state visualization. This story focuses on the essential UI elements without complex animations.

## Acceptance Criteria
- [ ] Microphone button with state-based icons and colors
- [ ] Recording timer display with MM:SS format
- [ ] Basic recording state indicators (recording/processing/error)
- [ ] Permission status indicators and badges
- [ ] Network connectivity status visualization
- [ ] Proper Material Design 3 theming integration

## Tasks Checklist

### Core UI Components
- [ ] Create `VoiceInputButton` widget (`src/presentation/widgets/voice_input_button.dart`)
- [ ] Implement state-based icon switching (mic → cancel/check)
- [ ] Add proper Material 3 color theming integration
- [ ] Create `VoiceInputTimer` widget (`src/presentation/widgets/voice_input_timer.dart`)
- [ ] Implement MM:SS timer format display

### Status Indicator Components
- [ ] Create `PermissionBadgeIcon` widget (`src/presentation/widgets/permission_badge_icon.dart`)
- [ ] Implement permission denied overlay (block icon)
- [ ] Create `OfflineBadgeIcon` widget (`src/presentation/widgets/offline_badge_icon.dart`)
- [ ] Implement offline status overlay (cloud_off icon)

### Recording State Components
- [ ] Create `VoiceRecordingIndicator` widget (`src/presentation/widgets/voice_recording_indicator.dart`)
- [ ] Implement basic recording state visualization
- [ ] Add processing state indicator (CircularProgressIndicator)
- [ ] Create error state display components

### BLoC Integration
- [ ] Create `VoiceInputBlocBuilder` helper widget
- [ ] Implement proper state-to-UI mapping
- [ ] Add BLoC event dispatching from UI interactions
- [ ] Handle loading states during transitions

### Material Design 3 Integration
- [ ] Use proper ColorScheme tokens (primary, error, onSurfaceVariant)
- [ ] Implement correct TextTheme styles (bodyLarge, headlineSmall)
- [ ] Add proper touch targets (minimum 48dp)
- [ ] Use Material 3 component specifications

### Accessibility Implementation
- [ ] Add semantic labels for all interactive elements
- [ ] Implement screen reader announcements for state changes
- [ ] Add tooltips for long-press actions
- [ ] Ensure high contrast support

## Testing Verification

### Widget Tests
- [ ] Test `VoiceInputButton` state transitions and interactions
- [ ] Test `VoiceInputTimer` formatting and updates
- [ ] Test permission and offline badge visibility
- [ ] Test recording indicator state changes
- [ ] Test accessibility features (semantic labels, tooltips)

### Integration Tests
- [ ] Test UI components with actual BLoC state changes
- [ ] Test user interactions trigger correct BLoC events
- [ ] Test theming integration with different color schemes
- [ ] Test responsive behavior on different screen sizes

### Manual Testing
- [ ] Verify all UI states render correctly
- [ ] Test touch interactions and button responses
- [ ] Verify tooltips appear on long press
- [ ] Test with different Material 3 themes
- [ ] Test accessibility with screen reader
- [ ] Test on both iOS and Android devices

## Dependencies
- Story 01: Project Setup and Foundation
- Story 02: Permission Management System
- Story 03: Audio Recording Implementation
- Story 04: Offline Transcription Implementation
- Story 05: Online Transcription Service

## Notes
- This story focuses on basic UI without complex animations
- All components should be reusable and well-structured
- Follow Material Design 3 specifications strictly
- Accessibility is a first-class concern, not an afterthought
- UI should work well on both mobile and tablet form factors
