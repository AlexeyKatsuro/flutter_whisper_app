import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_api/settings_api.dart';

part 'settings_bloc.freezed.dart';

/// A [Bloc] that handles [Settings].
final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
    required SettingsState initialState,
  }) : _settingsRepository = settingsRepository,
       super(initialState) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        _UpdateSettingsEvent() => _updateSettings(event, emit),
      },
    );
  }

  final SettingsRepository _settingsRepository;

  Future<void> _updateSettings(
    _UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsState.loading(settings: state.settings));
      await _settingsRepository.save(event.settings);
      emit(SettingsState.idle(settings: event.settings));
    } catch (error) {
      emit(SettingsState.error(settings: event.settings, error: error));
    }
  }
}

/// States for the [SettingsBloc].
@freezed
sealed class SettingsState with _$SettingsState {
  /// The settings are idle.
  const factory SettingsState.idle({Settings? settings}) = _IdleSettingsState;

  /// The settings are loading.
  const factory SettingsState.loading({Settings? settings}) = _LoadingSettingsState;

  /// The settings have an error.
  const factory SettingsState.error({
    required Object error,
    Settings? settings,
  }) = _ErrorSettingsState;
}

/// Events for the [SettingsBloc].
@freezed
sealed class SettingsEvent with _$SettingsEvent {
  /// Update the settings.
  const factory SettingsEvent.updateSettings({required Settings settings}) = _UpdateSettingsEvent;
}
