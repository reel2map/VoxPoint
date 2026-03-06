import 'package:flutter/widgets.dart';
import 'package:ui_kit/src/gen/fonts.gen.dart';

class TextStyles {
  static const TextStyle accent = TextStyle(
    fontFamily: FontFamily.commissioner,
    fontWeight: FontWeight.w700,
    height: 40 / 24,
    fontSize: 24,
    package: 'ui_kit',
  );

  static const TextStyle title = TextStyle(
    fontFamily: FontFamily.commissioner,
    fontWeight: FontWeight.w500,
    height: 24 / 18,
    fontSize: 18,
    package: 'ui_kit',
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: FontFamily.commissioner,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    fontSize: 16,
    package: 'ui_kit',
  );

  static const TextStyle body = TextStyle(
    fontFamily: FontFamily.commissioner,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    fontSize: 14,
    package: 'ui_kit',
  );

  static const TextStyle description = TextStyle(
    fontFamily: FontFamily.commissioner,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    fontSize: 12,
    package: 'ui_kit',
  );
}
