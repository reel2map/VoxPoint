import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AgentFilterBottomSheet extends StatefulWidget {
  const AgentFilterBottomSheet({required this.filter, super.key});

  final BotFilter filter;

  @override
  State<AgentFilterBottomSheet> createState() => AgentFilterBottomSheetState();
}

class AgentFilterBottomSheetState extends State<AgentFilterBottomSheet> {
  late BotFilter currentFilter;

  @override
  void initState() {
    currentFilter = widget.filter;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgentFilterBottomSheet oldWidget) {
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
                  ChatsI18n.status,
                  style: context.texts.title.copyWith(
                    color: context.colors.semiBlack,
                  ),
                ),
              ),
              ...BotStatus.values
                  .where((e) => e != BotStatus.unknown)
                  .map(
                    (e) => UiCheckBoxCell(
                      label: ChatsI18n.botStatusType(e),
                      value: currentFilter.statuses.contains(e),
                      onTap: (value) {
                        if (value) {
                          final statuses = [...currentFilter.statuses];

                          if (!statuses.contains(e)) {
                            statuses.add(e);
                            setState(() {
                              currentFilter = currentFilter.copyWith(
                                statuses: statuses,
                              );
                            });
                          }
                        } else {
                          final statuses = [...currentFilter.statuses];

                          if (statuses.contains(e)) {
                            statuses.remove(e);
                            setState(() {
                              currentFilter = currentFilter.copyWith(
                                statuses: statuses,
                              );
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
                      currentFilter = currentFilter.copyWith(statuses: []);
                    });
                  },
                ),
              ),
              const SizedBox(width: Insets.s),
              Expanded(
                child: UiButton(
                  label: ChatsI18n.accept,
                  onPressed: () {
                    Navigator.of(context).pop(currentFilter);
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
