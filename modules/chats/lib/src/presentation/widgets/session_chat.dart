import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionChat extends StatelessWidget {
  const SessionChat({
    required this.logs,
    required this.onCopilotTap,
    super.key,
    this.scrollController,
  });

  final List<LogEntity> logs;

  final AnchorScrollController? scrollController;

  final void Function(String text) onCopilotTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(Insets.l),
            itemBuilder: (context, index) {
              return AnchorItemWrapper(
                controller: scrollController,
                index: index,
                child: SessionChatMessage(
                  log: logs[index],
                  onCopilotTap: onCopilotTap,
                ),
              );
            },
            separatorBuilder:
                (context, index) => const SizedBox(height: Insets.s),
            itemCount: logs.length,
          ),
        ),
      ],
    );
  }
}
