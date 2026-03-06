import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

List<TextSpan> parseToRichText(String text, TextStyle style) {
  return text.split('`').asMap().entries.map((MapEntry<int, String> e) {
    if (e.key.isOdd) {
      return TextSpan(text: e.value, style: style);
    }

    return TextSpan(text: e.value);
  }).toList();
}

List<TextSpan> parseToLinksText(
  String text,
  List<Function> callbacks,
  TextStyle textStyle,
  TextStyle linkStyle,
) {
  final RegExp regex = RegExp('`[^`]+`');

  // ignore: prefer_asserts_with_message
  assert(regex.allMatches(text).length == callbacks.length);

  final List<RegExpMatch> items = regex.allMatches(text).toList();

  return text.split('`').asMap().entries.map((MapEntry<int, String> e) {
    if (e.key.isOdd) {
      final int index = items.indexWhere(
        (RegExpMatch element) => element.group(0) == '`${e.value}`',
      );

      return TextSpan(
        text: e.value,
        style: linkStyle,
        recognizer:
            TapGestureRecognizer()
              // ignore: avoid_dynamic_calls
              ..onTap = () => callbacks.elementAt(index)(),
      );
    }

    return TextSpan(text: e.value, style: textStyle);
  }).toList();
}
