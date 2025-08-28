# Voice Input Feature - UI/UX Specification

## 1. UX Flow (User Experience)

### Main Screen / Idle State
- User sees text input field with microphone icon button positioned in the input field's trailing area
- Network connectivity is indicated by microphone icon appearance:
  - Online: Standard microphone icon
  - Offline: Microphone icon with small crossed-out cloud overlay at bottom
  - Permission Denied: Microphone icon with small block icon (circle with slash) at bottom center (has priority over offline)
- Available interactions:
  - Tap microphone button: Initiates one of the following flows:
    - Permission Check State (if permission not yet requested)
    - Permission Denied State (if permission was denied)
    - Recording State (if permission is granted)
  - Long press microphone button: Shows tooltip "Voice input"
  - Tap text field: Opens keyboard for manual text input
- Transitions:
  - Microphone button tap → Permission Check State / Permission Denied State / Recording State
  - Text field tap → Standard text input mode

### Permission Check State
- Dialog shows system permission dialog with text: {voice_permission_rationale}
- Available interactions:
  - Tap "Allow": Grants permission and transitions to Recording State
  - Tap "Deny": Returns to Permission Denied State
- Transitions:
  - Permission granted → Recording State
  - Permission denied → Permission Denied State

### Permission Denied State
- SnackBar appears with message about denied permission and action button "Settings" (opens app settings for permissions)
- Microphone icon displays small block icon (circle with slash) at bottom center (badge position). If offline and denied, only block icon is shown.
- Available interactions:
  - Tap microphone button: Shows SnackBar again
  - Tap "Settings" in SnackBar: Opens app settings
- Transitions:
  - Permission granted in settings → Idle State (microphone icon returns to normal)

### Recording State
- Microphone icon transforms to close/cancel icon (X) and check icon (✓), both in trailing position of the TextField, side by side with minimal spacing.
- Visual recording indicator appears (animated sound waves around the icons).
- Recording timer displays current duration in MM:SS format, centered between icons.
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
- Check icon (✓) and close icon (X) disappear, replaced by a CircularProgressIndicator (24dp) in the trailing position where check icon was.
- Timer remains visible.
- No user interactions available during processing.
- Transitions:
  - Successful transcription → Success State
  - Audio file error (save/read failure) → Error State
  - API/transcription error → Error State
  - Other failures → Idle State (silent reset)

### Error State
- Error message is shown as a SnackBar with appropriate text (audio file error, API error, etc.).
- In trailing position, both close icon (X) and retry icon (refresh/replay) are shown side by side.
- Available interactions:
  - Tap retry icon: Retry transcription with same audio
  - Long press retry icon: Shows tooltip "Retry"
  - Tap close icon (X): Dismiss error and return to Idle State
  - Long press close icon: Shows tooltip "Cancel"
- Transitions:
  - Retry icon tap → Processing State (retry)
  - Close icon tap → Idle State

### Success State
- Transcribed text appears in the text input field.
- If the user had a cursor in the text field before recording, the recognized text is inserted at the cursor position, not just appended to the end.
- Loading indicator disappear and microphone button returns to normal idle state.
- Available interactions:
  - Edit transcribed text: Standard text editing
  - Tap microphone again: Add more voice input (inserts at current cursor position)
- Transitions:
  - Microphone tap → Recording State (inserts at cursor)
  - Text editing → Standard text input mode


## 2. UI Design (Visual Layout)

### Main Screen / Idle State

#### Layout & Positioning
- Text input field: Fixed to the bottom of the screen, full width, with 16dp horizontal padding, always above the keyboard.
- Microphone button: 24dp icon in trailing position of TextField.
- Offline overlay: `cloud_off` icon (8dp) using `outline` color token, positioned as a badge at the center-bottom of the microphone icon with 2dp offset down.
- Permission denied overlay: `block` icon (8dp) using `error` color token, positioned as a badge at the center-bottom of the microphone icon with 2dp offset down. If both offline and denied, only block icon is shown.

#### Components
- **Text Field**: `OutlinedTextField` with `bodyLarge` text style
- **Microphone Button**: `IconButton` with `mic` icon, `onSurfaceVariant` color when inactive
- **Offline Overlay**: `cloud_off` icon (8dp) as badge at center-bottom of mic icon
- **Permission Denied Overlay**: `block` icon (8dp) as badge at center-bottom of mic icon
- **Text**: Input hint uses `onSurfaceVariant` color and `bodyMedium` text style

### Recording State

#### Layout & Positioning
- Recording area: Replaces text field area during recording
- Close icon (X) and check icon (✓): Both in trailing position, side by side, 24dp size, minimal spacing
- Timer display: Centered horizontally between icons
- Sound waves: Animated around the entire recording area

#### Components
- **Close Icon**: `IconButton` with `close` icon using `error` color token
- **Timer**: `Text` component with `headlineSmall` style and `onSurface` color
- **Check Icon**: `IconButton` with `check` icon using `primary` color token
- **Sound Waves**: Custom animated overlay using `primaryContainer` color with opacity variations (0.3-0.8)
- **Tooltips**: "Cancel recording" for close icon, "Finish recording" for check icon
- **Container**: Rounded rectangle with `surfaceVariant` background and 12dp corner radius

### Processing State

#### Layout & Positioning
- Same layout as Recording State, but instead of icons, CircularProgressIndicator (24dp) is shown in trailing position where check icon was.
- Timer remains visible showing final recording duration.

#### Components
- **Loading Spinner**: `CircularProgressIndicator` (24dp) using `primary` color

### Error State

#### Layout & Positioning
- Same as Processing State, but in trailing position both close icon (X) and retry icon (refresh/replay) are shown side by side.
- Error message is shown as a SnackBar at the bottom of the screen.

#### Components
- **Close Icon**: Enabled `IconButton` with `close` icon using `error` color token
- **Retry Icon**: Enabled `IconButton` with `refresh` or `replay` icon using `primary` color token
- **SnackBar**: Material 3 SnackBar with error message and optional action
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
  },
  "voice_error_retry_icon": "refresh",
  "@voice_error_retry_icon": {
    "description": "Icon for retry button in error state"
  },
  "voice_permission_rationale": "Voice input requires access to your microphone to record and transcribe your speech.",
  "@voice_permission_rationale": {
    "description": "Rationale text shown in system permission dialog for microphone access"
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
  },
  "voice_error_retry_icon": "refresh",
  "@voice_error_retry_icon": {
    "description": "Иконка для кнопки повтора в состоянии ошибки"
  },
  "voice_permission_rationale": "Голосовой ввод требует доступа к вашему микрофону для записи и распознавания речи.",
  "@voice_permission_rationale": {
    "description": "Текст обоснования для системного диалога запроса доступа к микрофону"
  }
}
```

