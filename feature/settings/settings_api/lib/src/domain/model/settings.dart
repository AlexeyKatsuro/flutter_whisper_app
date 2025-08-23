import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_api/src/domain/model/theme_configuration.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// Settings for the app.
@freezed
class Settings with _$Settings {
  const factory Settings({
    ThemeConfiguration? themeConfiguration,
    @JsonKey(fromJson: _localeFromJson, toJson: _localeToJson) Locale? locale,
    double? textScale,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  static const initial = Settings(
    themeConfiguration: ThemeConfiguration(
      seedColor: Colors.blue,
      themeMode: ThemeModeVO.system,
    ),
    locale: Locale('en'),
    textScale: 1.0,
  );
}

Locale? _localeFromJson(String? languageCode) =>
    languageCode != null ? Locale(languageCode) : null;

String? _localeToJson(Locale? locale) => locale?.languageCode;
