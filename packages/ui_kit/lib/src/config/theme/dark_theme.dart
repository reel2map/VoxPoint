import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

ThemeData createDarkTheme() {
  final colors = DarkThemeColors();

  return ThemeData.dark(useMaterial3: true).copyWith(
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
