import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class BotCard extends StatelessWidget {
  const BotCard({
    required this.bot,
    required this.onPressedSessions,
    required this.onPressedStart,
    required this.onPressedStop,
    required this.onPressedDashboard,
    required this.onPressedSettings,
    super.key,
    this.user,
  });

  final BotEntity bot;

  final VoidCallback onPressedDashboard;

  final VoidCallback onPressedSessions;

  final VoidCallback onPressedStart;

  final VoidCallback onPressedStop;

  final VoidCallback onPressedSettings;

  final AuthenticatedUser? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  bot.name,
                  style: context.texts.title.copyWith(
                    color: context.colors.semiBlack,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.xxs,
                  horizontal: Insets.xs,
                ),
                child: Text(
                  bot.status.status.name.toUpperCase(),
                  style: context.texts.body.copyWith(
                    color: _statusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.s),
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bot.description?.isNotEmpty ?? false) ...[
                      Text(
                        bot.description ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: context.texts.subtitle.copyWith(
                          color: context.colors.mediumGrey,
                        ),
                      ),
                      const SizedBox(height: Insets.s),
                    ],
                    Text(
                      '${DateFormat(DateFormats.ddMMMyyyy).format(bot.createdOn.toLocal())}・${DateFormat(DateFormats.hhmm).format(bot.createdOn.toLocal())}',
                      style: context.texts.subtitle.copyWith(
                        color: context.colors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (user?.role.isTenantAdmin ?? false)
                IconButton(
                  onPressed: () {
                    if (bot.status.status == BotStatus.running) {
                      context.read<BotsCubit>().stopBot(bot.id);
                    }

                    if (bot.status.status == BotStatus.stopped) {
                      context.read<BotsCubit>().startBot(bot.id);
                    }
                  },
                  icon: Icon(switch (bot.status.status) {
                    BotStatus.stopped => Icons.play_circle_outline,
                    BotStatus.running => Icons.stop_circle_outlined,
                    BotStatus.stopping => Icons.stop_circle_outlined,
                    BotStatus.starting => Icons.stop_circle_outlined,
                    BotStatus.error => Icons.stop_circle_outlined,
                    BotStatus.unknown => Icons.stop_circle_outlined,
                  }, size: Insets.xxl),
                ),
            ],
          ),

          const SizedBox(height: Insets.l),
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: onPressedDashboard,
                  icon: Analytics(
                    color: context.colors.darkGrey,
                    size: const Size.square(Insets.xl),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: onPressedSessions,
                  icon: UiIcon(
                    Assets.icons.sessionsIcon.path,
                    width: Insets.xl,
                    color: context.colors.darkGrey,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: onPressedSettings,
                  icon: const Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    return switch (bot.status.status) {
      BotStatus.stopped => const Color(0xFFF1B709),
      BotStatus.running => const Color(0xFF18C63E),
      BotStatus.stopping => const Color(0xFFF1B709),
      BotStatus.starting => const Color(0xFFF1B709),
      BotStatus.error => const Color(0xFFF1B709),
      BotStatus.unknown => const Color(0xFFF1B709),
    };
  }
}
