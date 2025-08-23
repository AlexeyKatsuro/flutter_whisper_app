import 'dart:ui' show Color;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_configuration.freezed.dart';
part 'theme_configuration.g.dart';

enum ThemeModeVO { light, dark, system }

/// Class that holds values used for constructing a theme for the app.
@freezed
class ThemeConfiguration with _$ThemeConfiguration {
  const factory ThemeConfiguration({
    required ThemeModeVO themeMode,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color seedColor,
  }) = _ThemeConfiguration;

  factory ThemeConfiguration.fromJson(Map<String, dynamic> json) => _$ThemeConfigurationFromJson(json);
}

Color _colorFromJson(int value) => Color(value);

int _colorToJson(Color color) => color.value;
