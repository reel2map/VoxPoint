import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class InputCell extends StatelessWidget {
  const InputCell({
    required this.title,
    required this.text,
    super.key,
    this.onPressed,
    this.titleColor,
  });

  final String title;

  final String text;

  final Color? titleColor;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: Insets.m,
        children: [
          Text(
            title,
            style: context.texts.subtitle.copyWith(
              color: titleColor ?? context.colors.semiBlack,
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Insets.xs,
                horizontal: Insets.s,
              ),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFCDCDCD))),
              ),
              child: Text(
                text,
                style: context.texts.subtitle.copyWith(
                  color: context.colors.darkGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
