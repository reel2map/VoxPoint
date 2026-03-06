import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class KeyItemNumber extends StatelessWidget {
  const KeyItemNumber({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.texts.accent.copyWith(
        color: context.colors.black80,
        height: 1,
      ),
    );
  }
}
