import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class TextExtension extends ThemeExtension<TextExtension> {
  const TextExtension.light({
    this.accent = TextStyles.accent,
    this.title = TextStyles.title,
    this.subtitle = TextStyles.subtitle,
    this.body = TextStyles.body,
    this.description = TextStyles.description,
  }) : _isDark = false;

  const TextExtension.dark({
    this.accent = TextStyles.accent,
    this.title = TextStyles.title,
    this.subtitle = TextStyles.subtitle,
    this.body = TextStyles.body,
    this.description = TextStyles.description,
  }) : _isDark = true;

  final TextStyle accent;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle description;

  final bool _isDark;

  @override
  ThemeExtension<TextExtension> copyWith({
    TextStyle? accent,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? description,
  }) {
    if (_isDark) {
      return TextExtension.dark(
        accent: accent ?? this.accent,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        body: body ?? this.body,
        description: description ?? this.description,
      );
    }

    return TextExtension.light(
      accent: accent ?? this.accent,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      description: description ?? this.description,
    );
  }

  @override
  ThemeExtension<TextExtension> lerp(
    ThemeExtension<TextExtension>? other,
    double t,
  ) {
    if (other is! TextExtension) {
      return this;
    }

    if (_isDark) {
      return const TextExtension.dark();
    }

    return const TextExtension.light();
  }
}
