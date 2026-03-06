import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ChannelsFilter extends StatelessWidget {
  const ChannelsFilter({
    required this.filter,
    required this.onChangeFilter,
    super.key,
  });

  final SessionFilter filter;

  final void Function(SessionFilter filter) onChangeFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UiCheckBoxCell(
          label: ChatsI18n.all,
          value: filter.userType == null,
          onTap: (value) {
            if (value) {
              onChangeFilter(filter.copyWith(userType: null));
            }
          },
        ),
        ...SessionUserType.values
            .where((e) => e != SessionUserType.unknown)
            .map(
              (e) => UiCheckBoxCell(
                label: e.name,
                value: filter.userType == e,
                onTap: (value) {
                  if (value) {
                    onChangeFilter(filter.copyWith(userType: e));
                  } else {
                    onChangeFilter(filter.copyWith(userType: null));
                  }
                },
              ),
            ),
      ],
    );
  }
}
