import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class DashboardCampaignAppBar extends StatelessWidget {
  const DashboardCampaignAppBar({
    required this.filter,
    super.key,
    this.onPressedCampaignFilter,
    this.onPressedPeriodFilter,
  });

  final DashboardCampaignFilter filter;

  final VoidCallback? onPressedCampaignFilter;

  final VoidCallback? onPressedPeriodFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Insets.s,
      children: [
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: onPressedCampaignFilter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: const Color(0xFFDBDBDB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Insets.l),
                child: Row(
                  children: [
                    UiIcon(Assets.icons.filter.path),
                    const SizedBox(width: Insets.s),
                    Expanded(
                      child: Text(
                        filter.campaign?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: context.texts.subtitle.copyWith(
                          color: context.colors.darkGreyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onPressedPeriodFilter,
          child: Container(
            constraints: const BoxConstraints(minWidth: Insets.xxxl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFDBDBDB)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Insets.l),
              child: Row(
                children: [
                  UiIcon(Assets.icons.calendarMark.path),
                  const SizedBox(width: Insets.s),
                  Text(
                    ChatsI18n.periodType(filter.period),
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.subtitle.copyWith(
                      color: context.colors.darkGreyText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
