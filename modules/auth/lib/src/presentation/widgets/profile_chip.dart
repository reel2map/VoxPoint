import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileChip extends StatelessWidget {
  const ProfileChip({
    required this.title,
    required this.selected,
    super.key,
    this.width,
  });

  final String title;

  final bool selected;

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(Insets.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Insets.xl),
        border:
            selected
                ? Border.all(color: context.colors.mainOrange, width: 2)
                : Border.all(color: context.colors.lightGrey),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: context.texts.subtitle.copyWith(color: context.colors.darkGrey),
      ),
    );
  }
}
