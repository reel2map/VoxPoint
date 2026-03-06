import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    required this.session,
    required this.users,
    required this.onPressedSession,
    super.key,
  });

  final SessionEntity session;

  final List<SessionUserEntity> users;

  final VoidCallback onPressedSession;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressedSession,
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Insets.xs,
                    children: [
                      Flexible(
                        child: Text(
                          // session.envInfo,
                          session.user.name ?? '',
                          style: context.texts.title.copyWith(
                            color: context.colors.semiBlack,
                          ),
                        ),
                      ),
                      if (session.finishTime == null) const SessionIndicator(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
                  child: switch (session.sessionType) {
                    SessionType.regular => Text(
                      'AI',
                      style: context.texts.title.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                    SessionType.copilot =>
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (session.operatorId == null) {
                            return const Icon(Icons.account_circle);
                          }

                          final operator =
                              state.users
                                  .firstWhereOrNull(
                                    (e) =>
                                        session.operatorId ==
                                        e.authenticatedOrNull?.id,
                                  )
                                  ?.authenticatedOrNull;

                          if (operator?.fullName != null) {
                            return Container(
                              width: Insets.xl,
                              height: Insets.xl,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colors.extraLightGrey,
                              ),
                              child: Center(
                                child: Text(
                                  operator?.fullName.substring(0, 1) ?? '',
                                  style: context.texts.title.copyWith(
                                    color: context.colors.semiBlack,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Icon(Icons.account_circle);
                          }
                        },
                      ),
                    SessionType.operator =>
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (session.operatorId == null) {
                            return const Icon(Icons.account_circle);
                          }

                          final operator =
                              state.users
                                  .firstWhereOrNull(
                                    (e) =>
                                        session.operatorId ==
                                        e.authenticatedOrNull?.id,
                                  )
                                  ?.authenticatedOrNull;

                          if (operator?.fullName != null) {
                            return Container(
                              width: Insets.xl,
                              height: Insets.xl,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colors.extraLightGrey,
                              ),
                              child: Center(
                                child: Text(
                                  operator?.fullName.substring(0, 1) ?? '',
                                  style: context.texts.title.copyWith(
                                    color: context.colors.semiBlack,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Icon(Icons.account_circle);
                          }
                        },
                      ),

                    SessionType.unknown => Text(
                      'AI',
                      style: context.texts.title.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  },
                ),

                if (session.userInfo?['country_code'] != null)
                  Padding(
                    padding: const EdgeInsets.only(right: Insets.s),
                    child: Flag.fromString(
                      session.userInfo?['country_code']
                              ?.toString()
                              .toLowerCase() ??
                          '',
                      width: Insets.xl,
                      height: Insets.l,
                    ),
                  ),
                IntegrationIcon(type: session.user.type.name),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${session.logsCount}',
                    style: context.texts.title.copyWith(
                      color: context.colors.semiBlack,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.s),
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.bot?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.subtitle.copyWith(
                      color: context.colors.mediumGrey,
                    ),
                  ),
                ),
                if (session.lastMessageTime != null)
                  Text(
                    '${DateFormat(DateFormats.hhmm).format(session.lastMessageTime!.toLocal())}・${DateFormat(DateFormats.ddMMMyy).format(session.lastMessageTime!.toLocal())}',
                    style: context.texts.subtitle.copyWith(
                      color: context.colors.mediumGrey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
