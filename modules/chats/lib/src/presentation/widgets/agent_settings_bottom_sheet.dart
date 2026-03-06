import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AgentSettingsBottomSheet extends StatefulWidget {
  const AgentSettingsBottomSheet({
    required this.user,
    required this.botId,
    super.key,
  });

  final AuthenticatedUser user;

  final String botId;

  @override
  State<AgentSettingsBottomSheet> createState() =>
      AgentSettingsBottomSheetState();
}

class AgentSettingsBottomSheetState extends State<AgentSettingsBottomSheet> {
  late List<MobilePushConfigSettings> currentEvents;

  @override
  void initState() {
    currentEvents =
        widget.user.mobilePushConfig.subscriptions
            .firstWhereOrNull((e) => e.botId == widget.botId)
            ?.events ??
        [];

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgentSettingsBottomSheet oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.m,
                  horizontal: Insets.xl,
                ),
                child: Text(
                  ChatsI18n.clientPushNotification,
                  style: context.texts.title.copyWith(
                    color: context.colors.semiBlack,
                  ),
                ),
              ),
              ...MobilePushConfigSettings.values
                  .where((e) => e != MobilePushConfigSettings.messageFromAi)
                  .map(
                    (e) => UiCheckBoxCell(
                      label: ChatsI18n.pushNotifications(e),
                      value: currentEvents.contains(e),
                      onTap: (value) {
                        if (value) {
                          final events = [...currentEvents];

                          if (!events.contains(e)) {
                            events.add(e);
                            setState(() {
                              currentEvents = events;
                            });
                          }
                        } else {
                          final events = [...currentEvents];

                          if (events.contains(e)) {
                            events.remove(e);
                            setState(() {
                              currentEvents = events;
                            });
                          }
                        }
                      },
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: Insets.xl),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.m,
            horizontal: Insets.xl,
          ),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.colors.lightGrey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: UiButton(
                  type: UiButtonType.secondary,
                  label: ChatsI18n.clear,
                  onPressed: () {
                    setState(() {
                      currentEvents.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: Insets.s),
              Expanded(
                child: UiButton(
                  label: ChatsI18n.accept,
                  onPressed: () {
                    Navigator.of(context).pop(currentEvents);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
