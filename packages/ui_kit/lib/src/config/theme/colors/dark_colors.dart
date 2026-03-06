import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class DarkThemeColors implements ThemeColors {
  @override
  Color get black100 => const Color(0xFF000000);

  @override
  Color get black80 => const Color(0xCC000000);

  @override
  Color get darkGrey => const Color(0xFF6F717E);

  @override
  Color get extraLightGrey => const Color(0xFFF5F5F6);

  @override
  Color get lightGrey => const Color(0xFFD6D7E0);

  @override
  Color get mainOrange => const Color(0xFFFA8434);

  @override
  Color get mainOrange10 => const Color(0x1AFA8434);

  @override
  Color get mediumGrey => const Color(0xFF8F929F);

  @override
  LinearGradient get orangeWhite => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.5],
    colors: [Color(0xFFFA8434), Color.fromARGB(255, 255, 121, 109)],
  );

  @override
  Color get semiBlack => const Color(0xFF5A5C66);

  @override
  Color get white100 => const Color(0xFFFFFFFF);

  @override
  Color get background => const Color(0xFFF5F5F6);

  @override
  Color get darkGreyText => const Color(0xFF5A5C66);
}
