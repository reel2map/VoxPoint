import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiCopyNotify extends StatelessWidget {
  const UiCopyNotify({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(Insets.s),
            decoration: const BoxDecoration(
              //  color: context.colors.darkGrey,
              shape: BoxShape.circle,
            ),
            child: UiIcon(
              Assets.icons.copySuccess.path,
              color: context.colors.darkGrey,
            ),
          ),
          const SizedBox(width: Insets.m),
          Expanded(
            child: DefaultTextStyle(
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: Insets.l,
                overflow: TextOverflow.ellipsis,
              ),
              child: Text(title),
            ),
          ),
        ],
      ),
    );
  }
}
