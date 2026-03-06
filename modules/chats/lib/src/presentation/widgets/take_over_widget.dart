import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class TakeOverWidget extends StatelessWidget {
  const TakeOverWidget({
    required this.onPressedDecline,
    required this.onPressedAccept,
    required this.title,
    required this.description,
    super.key,
  });
  final String title;

  final String description;

  final VoidCallback onPressedDecline;

  final VoidCallback onPressedAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xl,
        horizontal: Insets.l,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.lightGrey)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: context.texts.subtitle.copyWith(
              color: context.colors.semiBlack,
            ),
          ),
          const SizedBox(height: Insets.s),
          Text(
            description,
            style: context.texts.body.copyWith(color: context.colors.darkGrey),
          ),
          const SizedBox(height: Insets.l),
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: UiButton(
                  type: UiButtonType.secondary,
                  onPressed: onPressedDecline,
                  label: ChatsI18n.decline,
                ),
              ),
              Expanded(
                child: UiButton(
                  onPressed: onPressedAccept,
                  label: ChatsI18n.accept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
