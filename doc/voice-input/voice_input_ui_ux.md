# Voice Input Feature - UI/UX Specification

## 1. UX Flow (User Experience)

### Main Screen / Idle State
- User sees text input field with microphone icon button positioned in the input field's trailing area
- Network connectivity is indicated by microphone icon appearance:
  - Online: Standard microphone icon
  - Offline: Microphone icon with small crossed-out cloud overlay at bottom
- Available interactions:
  - Tap microphone button: Initiates voice input flow
  - Long press microphone button: Shows tooltip "Voice input"
  - Tap text field: Opens keyboard for manual text input
- Transitions:
  - Microphone button tap → Permission Check State (if permissions not granted) or Recording State (if permissions available)
  - Text field tap → Standard text input mode

### Permission Check State
- System permission dialog appears requesting microphone access
- Dialog shows clear explanation of why voice input needs microphone permission
- Available interactions:
  - Tap "Allow": Grants permission and transitions to Recording State
  - Tap "Deny": Returns to Idle State with disabled microphone button
- Transitions:
  - Permission granted → Recording State
  - Permission denied → Idle State with permission explanation message

### Recording State
- Microphone icon transforms to close/cancel icon (X)
- Visual recording indicator appears (animated sound waves around the icon)
- Recording timer displays current duration in MM:SS format
- Check icon (✓) appears as finish button
- Available interactions:
  - Tap check icon (✓): Stops recording and transitions to Processing State
  - Long press check icon: Shows tooltip "Finish recording"
  - Tap close icon (X): Cancels recording and returns to Idle State
  - Long press close icon: Shows tooltip "Cancel recording"
  - Speaking: Audio is captured and visual feedback shows sound levels through wave animation
- Transitions:
  - Check icon tap → Processing State
  - Close icon tap → Idle State
  - 60-second limit reached → Auto-transition to Processing State

### Processing State
- Check icon (✓) and close icon (X) remain visible but disabled
- Small loading spinner appears between the two icons
- Recording timer remains visible showing final duration
- No user interactions available during processing
- Transitions:
  - Successful transcription → Success State
  - Audio file error (save/read failure) → Error State
  - API/transcription error → Error State
  - Other failures → Idle State (silent reset)

### Error State
- Error message appears below the recording area
- Check icon (✓) and close icon (X) remain visible and enabled
- Available interactions:
  - Tap check icon (✓): Retry transcription with same audio
  - Long press check icon: Shows tooltip "Retry"
  - Tap close icon (X): Dismiss error and return to Idle State
  - Long press close icon: Shows tooltip "Cancel"
- Transitions:
  - Check icon tap → Processing State (retry)
  - Close icon tap → Idle State

### Success State
- Transcribed text appears in the text input field
- Text cursor positioned at end of transcribed content
- Icons disappear and microphone button returns to normal idle state
- Available interactions:
  - Edit transcribed text: Standard text editing
  - Tap microphone again: Add more voice input (appends to existing text)
- Transitions:
  - Microphone tap → Recording State (appends to existing text)
  - Text editing → Standard text input mode

### Edge Cases & Error Handling

#### Error States
- No microphone permission: Clear explanation with settings link, returns to Idle State
- No network connection: Shows crossed-out cloud overlay, continues with offline processing
- Audio file save/read error: Error message with retry option using same audio
- API/transcription service error: Error message with retry option
- Audio too short/silent: Automatic reset to Idle State
- Recording interrupted: Returns to Idle State

#### Empty States
- No audio captured: Automatic reset to Idle State
- Silent recording: Automatic reset to Idle State
- No transcription result: Automatic reset to Idle State

#### Success/Failure Feedback
- Successful recording: Subtle haptic feedback and sound wave animation
- Successful transcription: Text appears with brief highlight animation, return to Idle State
- Audio/API errors: Error message with retry option using check icon
- Other errors: Silent reset to Idle State, user can try again normally
- Network status: Visual indication through crossed-out cloud overlay when offline

## 2. UI Design (Visual Layout)

### Main Screen / Idle State

#### Layout & Positioning
- Text input field: Material 3 `TextField` component with standard 56dp height
- Microphone button: 24dp icon positioned in `TextField` trailing slot with 12dp padding
- Offline indicator overlay: 8dp crossed-out cloud icon positioned at bottom-right of microphone icon with 2dp offset
- Spacing follows Material spacing scale: 8dp, 12dp, 16dp, 24dp

#### Components
- **Text Field**: `OutlinedTextField` with `bodyLarge` text style
- **Microphone Button**: `IconButton` with `mic` icon, `onSurfaceVariant` color when inactive
- **Offline Overlay**: `cloud_off` icon (8dp) using `outline` color token, positioned with stack overlay
- **Text**: Input hint uses `onSurfaceVariant` color and `bodyMedium` text style

### Recording State

#### Layout & Positioning
- Recording area: Replaces text field area during recording
- Close icon (X): Positioned left side with 24dp size
- Timer display: Centered horizontally between icons
- Check icon (✓): Positioned right side with 24dp size
- Sound waves: Animated around the entire recording area
- Icons spacing: 16dp padding from container edges, 24dp minimum spacing between icons

#### Components
- **Close Icon**: `IconButton` with `close` icon using `error` color token
- **Timer**: `Text` component with `headlineSmall` style and `onSurface` color
- **Check Icon**: `IconButton` with `check` icon using `primary` color token
- **Sound Waves**: Custom animated overlay using `primaryContainer` color with opacity variations (0.3-0.8)
- **Tooltips**: "Cancel recording" for close icon, "Finish recording" for check icon
- **Container**: Rounded rectangle with `surfaceVariant` background and 12dp corner radius

### Processing State

#### Layout & Positioning
- Same layout as Recording State but with icons disabled
- Loading spinner: 16dp size centered between the two icons
- Timer: Remains visible showing final recording duration
- Icons: Grayed out but still visible

#### Components
- **Close Icon**: Disabled state with `onSurface` color at 0.38 opacity
- **Check Icon**: Disabled state with `onSurface` color at 0.38 opacity
- **Loading Spinner**: `CircularProgressIndicator` (16dp) using `primary` color
- **Timer**: Same styling as Recording State
- **Background**: Same container as Recording State

### Success State

#### Layout & Positioning
- Returns to standard text field layout
- Text field: Populated with transcribed content
- Microphone button: Returns to idle state appearance
- Brief highlight animation on transcribed text

#### Components
- **Text Field**: `OutlinedTextField` with transcribed content using `bodyLarge` style
- **Microphone Button**: Standard `mic` icon with `onSurfaceVariant` color
- **Text Highlight**: Brief animation using `primary` color with 0.2 opacity overlay
- **Text Selection**: Standard Material 3 text selection handles and cursor

### Permission Check State

#### Layout & Positioning
- System dialog: Platform-standard permission dialog
- Explanation text: Positioned in dialog or below main UI with 12dp spacing
- Helper icon: 24dp microphone icon with explanation

#### Components
- **Permission Dialog**: System-provided component (platform-specific styling)
- **Explanation Card**: `Card` with `surfaceVariant` background and 12dp padding
- **Helper Text**: `bodyMedium` text style with `onSurfaceVariant` color
- **Icon**: `mic` icon using `primary` color token

### Error State

#### Layout & Positioning
- Same layout as Processing State with icons enabled
- Error message: Positioned below the recording area with 8dp spacing
- Error container: Full width with 12dp horizontal padding
- Icons remain in same positions as Processing State

#### Components
- **Close Icon**: Enabled `IconButton` with `close` icon using `error` color token
- **Check Icon**: Enabled `IconButton` with `check` icon using `primary` color token
- **Error Container**: `Card` component with `errorContainer` surface color and 8dp corner radius
- **Error Text**: `bodyMedium` text style with `onErrorContainer` color
- **Timer**: Same styling as Processing State showing final duration



## 3. JSON Copy Table

### English (EN)
```json
{
  "@@locale": "en",
  "voice_input_hint": "Tap microphone to speak",
  "@voice_input_hint": {
    "description": "Hint text shown in text field when voice input is available"
  },
  "voice_input_tooltip": "Voice input",
  "@voice_input_tooltip": {
    "description": "Tooltip for microphone button on long press"
  },
  "voice_recording_timer": "{minutes}:{seconds}",
  "@voice_recording_timer": {
    "description": "Timer format during voice recording",
    "placeholders": {
      "minutes": {
        "type": "String"
      },
      "seconds": {
        "type": "String"
      }
    }
  },
  "voice_recording_finish_tooltip": "Finish recording",
  "@voice_recording_finish_tooltip": {
    "description": "Tooltip for check icon to finish recording"
  },
  "voice_recording_cancel_tooltip": "Cancel recording",
  "@voice_recording_cancel_tooltip": {
    "description": "Tooltip for close icon to cancel recording"
  },
  "voice_error_retry_tooltip": "Retry",
  "@voice_error_retry_tooltip": {
    "description": "Tooltip for check icon in error state to retry"
  },
  "voice_error_cancel_tooltip": "Cancel",
  "@voice_error_cancel_tooltip": {
    "description": "Tooltip for close icon in error state to cancel"
  },
  "voice_error_audio_file": "Could not save or read audio file. Please try again.",
  "@voice_error_audio_file": {
    "description": "Error message when audio file operations fail"
  },
  "voice_error_api_transcription": "Transcription service error. Please try again.",
  "@voice_error_api_transcription": {
    "description": "Error message when API or transcription service fails"
  },
  "voice_paused_banner_title": "Recording Paused",
  "@voice_paused_banner_title": {
    "description": "Title shown when voice recording is paused"
  },
  "voice_paused_banner_message": "Voice recording paused while app was in background",
  "@voice_paused_banner_message": {
    "description": "Explanation message for paused recording"
  },
  "voice_paused_resume_tooltip": "Resume recording",
  "@voice_paused_resume_tooltip": {
    "description": "Tooltip for resume button in paused state"
  },
  "voice_paused_cancel_tooltip": "Cancel recording",
  "@voice_paused_cancel_tooltip": {
    "description": "Tooltip for cancel button in paused state"
  },
  "voice_error_permission_title": "Microphone Permission Required",
  "@voice_error_permission_title": {
    "description": "Title for microphone permission error"
  },
  "voice_error_permission_message": "Please allow microphone access to use voice input",
  "@voice_error_permission_message": {
    "description": "Explanation message for microphone permission request"
  },
  "voice_permission_settings_button": "Open Settings",
  "@voice_permission_settings_button": {
    "description": "Button to open app settings for permission management"
  }
}
```

### Russian (RU)
```json
{
  "@@locale": "ru",
  "voice_input_hint": "Нажмите микрофон для записи",
  "@voice_input_hint": {
    "description": "Подсказка в текстовом поле когда доступен голосовой ввод"
  },
  "voice_input_tooltip": "Голосовой ввод",
  "@voice_input_tooltip": {
    "description": "Тултип для кнопки микрофона при долгом нажатии"
  },
  "voice_recording_timer": "{minutes}:{seconds}",
  "@voice_recording_timer": {
    "description": "Формат таймера во время записи голоса",
    "placeholders": {
      "minutes": {
        "type": "String"
      },
      "seconds": {
        "type": "String"
      }
    }
  },
  "voice_recording_finish_tooltip": "Завершить запись",
  "@voice_recording_finish_tooltip": {
    "description": "Тултип для иконки галочки завершения записи"
  },
  "voice_recording_cancel_tooltip": "Отменить запись",
  "@voice_recording_cancel_tooltip": {
    "description": "Тултип для иконки крестика отмены записи"
  },
  "voice_error_retry_tooltip": "Повторить",
  "@voice_error_retry_tooltip": {
    "description": "Тултип для иконки галочки в состоянии ошибки для повтора"
  },
  "voice_error_cancel_tooltip": "Отмена",
  "@voice_error_cancel_tooltip": {
    "description": "Тултип для иконки крестика в состоянии ошибки для отмены"
  },
  "voice_error_audio_file": "Не удалось сохранить или прочитать аудио файл. Попробуйте снова.",
  "@voice_error_audio_file": {
    "description": "Сообщение об ошибке при работе с аудио файлом"
  },
  "voice_error_api_transcription": "Ошибка сервиса распознавания. Попробуйте снова.",
  "@voice_error_api_transcription": {
    "description": "Сообщение об ошибке API или сервиса распознавания"
  },
  "voice_paused_banner_title": "Запись приостановлена",
  "@voice_paused_banner_title": {
    "description": "Заголовок когда запись голоса приостановлена"
  },
  "voice_paused_banner_message": "Запись голоса приостановлена пока приложение было в фоне",
  "@voice_paused_banner_message": {
    "description": "Сообщение с объяснением приостановленной записи"
  },
  "voice_paused_resume_tooltip": "Продолжить запись",
  "@voice_paused_resume_tooltip": {
    "description": "Тултип для кнопки возобновления записи"
  },
  "voice_paused_cancel_tooltip": "Отменить запись",
  "@voice_paused_cancel_tooltip": {
    "description": "Тултип для кнопки отмены в приостановленном состоянии"
  },
  "voice_error_permission_title": "Требуется разрешение на микрофон",
  "@voice_error_permission_title": {
    "description": "Заголовок ошибки разрешения микрофона"
  },
  "voice_error_permission_message": "Пожалуйста, разрешите доступ к микрофону для голосового ввода",
  "@voice_error_permission_message": {
    "description": "Сообщение с объяснением запроса разрешения микрофона"
  },
  "voice_permission_settings_button": "Открыть настройки",
  "@voice_permission_settings_button": {
    "description": "Кнопка открытия настроек приложения для управления разрешениями"
  }
}
```

