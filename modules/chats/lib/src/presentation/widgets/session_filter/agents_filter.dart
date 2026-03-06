import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AgentsFilter extends StatelessWidget {
  const AgentsFilter({
    required this.bots,
    required this.filter,
    required this.onChangeFilter,
    super.key,
  });

  final List<BotEntity> bots;

  final SessionFilter filter;

  final void Function(SessionFilter filter) onChangeFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiCheckBoxCell(
          label: ChatsI18n.all,
          value: filter.bot == null,
          onTap: (value) {
            if (value) {
              onChangeFilter(filter.copyWith(bot: null));
            }
          },
        ),
        ...bots.map(
          (e) => UiCheckBoxCell(
            label: e.name,
            value: filter.bot == e,
            onTap: (value) {
              if (value) {
                onChangeFilter(filter.copyWith(bot: e));
              } else {
                onChangeFilter(filter.copyWith(bot: null));
              }
            },
          ),
        ),
      ],
    );
  }
}
