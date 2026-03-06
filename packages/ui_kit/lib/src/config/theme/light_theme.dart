import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

ThemeData createLightTheme() {
  final colors = LightThemeColors();

  return ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.light(primary: colors.mainOrange),
    scaffoldBackgroundColor: colors.background,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.white100,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colors.mainOrange,
      selectionColor: colors.mainOrange10,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: colors.semiBlack,
      displayColor: colors.semiBlack,
      decorationColor: colors.semiBlack,
    ),
    appBarTheme: AppBarTheme(
      color: colors.background,
      iconTheme: IconThemeData(color: colors.darkGreyText),
      scrolledUnderElevation: 0,
    ),
    extensions: <ThemeExtension<dynamic>>[const TextExtension.light()],
    iconTheme: IconThemeData(color: colors.darkGrey),
  );
}
