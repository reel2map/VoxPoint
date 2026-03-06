import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionResolveConfirmBottomSheet extends StatefulWidget {
  const SessionResolveConfirmBottomSheet({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;

  final String description;

  @override
  State<SessionResolveConfirmBottomSheet> createState() =>
      SessionResolveConfirmBottomSheetState();
}

class SessionResolveConfirmBottomSheetState
    extends State<SessionResolveConfirmBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionResolveConfirmBottomSheet oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.l),
      decoration: BoxDecoration(
        color: context.colors.white100,
        border: Border(top: BorderSide(color: context.colors.lightGrey)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: context.texts.subtitle.copyWith(
              color: context.colors.semiBlack,
            ),
          ),
          const SizedBox(height: Insets.s),
          Text(
            widget.description,
            style: context.texts.body.copyWith(color: context.colors.darkGrey),
          ),
          const SizedBox(height: Insets.l),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Insets.m,
              horizontal: Insets.xl,
            ),
            child: Row(
              children: [
                Expanded(
                  child: UiButton(
                    type: UiButtonType.secondary,
                    label: ChatsI18n.cancel,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: Insets.s),
                Expanded(
                  child: UiButton(
                    label: ChatsI18n.ok,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),
        ],
      ),
    );
  }
}
