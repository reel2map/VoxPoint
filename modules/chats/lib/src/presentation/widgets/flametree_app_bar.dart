import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class FlametreeAppBar extends StatelessWidget {
  const FlametreeAppBar({
    required this.title,
    required this.onPressedProfile,
    super.key,
  });

  final String title;

  final VoidCallback? onPressedProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.xl,
        vertical: Insets.xl,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.texts.accent.copyWith(
                color: context.colors.darkGreyText,
              ),
            ),
          ),
          InkWell(
            onTap: onPressedProfile,
            child: const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          ),
        ],
      ),
    );
  }
}
