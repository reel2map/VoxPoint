import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

enum SessionFilterType { agents, channels }

class SessionFilterItemBottomSheet extends StatefulWidget {
  const SessionFilterItemBottomSheet({
    required this.filter,
    required this.filterType,
    this.bots = const [],
    super.key,
  });

  final SessionFilterType filterType;

  final SessionFilter filter;

  final List<BotEntity> bots;

  @override
  State<SessionFilterItemBottomSheet> createState() =>
      SessionFilterItemBottomSheetState();
}

class SessionFilterItemBottomSheetState
    extends State<SessionFilterItemBottomSheet> {
  late SessionFilter currentFilter;

  @override
  void initState() {
    currentFilter = widget.filter;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionFilterItemBottomSheet oldWidget) {
    setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.filterType == SessionFilterType.agents)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Insets.m,
                horizontal: Insets.xl,
              ),
              child: Text(
                ChatsI18n.agent,
                style: context.texts.title.copyWith(
                  color: context.colors.semiBlack,
                ),
              ),
            ),
          if (widget.filterType == SessionFilterType.channels)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Insets.m,
                horizontal: Insets.xl,
              ),
              child: Text(
                ChatsI18n.communicationChannel,
                style: context.texts.title.copyWith(
                  color: context.colors.semiBlack,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.filterType == SessionFilterType.agents)
                    AgentsFilter(
                      bots: widget.bots,
                      filter: currentFilter,
                      onChangeFilter: (filter) {
                        setState(() {
                          currentFilter = filter;
                        });
                      },
                    ),
                  if (widget.filterType == SessionFilterType.channels)
                    ChannelsFilter(
                      filter: currentFilter,
                      onChangeFilter: (filter) {
                        setState(() {
                          currentFilter = filter;
                        });
                      },
                    ),
                ],
              ),
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
                        if (widget.filterType == SessionFilterType.agents) {
                          currentFilter = widget.filter.copyWith(bot: null);
                        }
                        if (widget.filterType == SessionFilterType.channels) {
                          currentFilter = widget.filter.copyWith(
                            userType: null,
                          );
                        }
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
      ),
    );
  }
}
