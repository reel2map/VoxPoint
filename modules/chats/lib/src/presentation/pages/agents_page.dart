import 'dart:async';

import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class AgentsPage extends StatefulWidget {
  const AgentsPage({super.key});

  @override
  State<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  final StreamController<SwipeRefreshState> _controller =
      StreamController.broadcast();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BotsCubit, BotsState>(
      listener: (context, state) {
        if (state.status.isFetchingInProgress) {
          _controller.add(SwipeRefreshState.loading);
        } else {
          _controller.add(SwipeRefreshState.hidden);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                FlametreeSearchBar(
                  control: state.searchControl,
                  onPressedFilter: () async {
                    final result = await showModalBottomSheet<BotFilter>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: context.colors.white100,
                      useRootNavigator: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Insets.xl),
                        ),
                      ),
                      builder: (context) {
                        return UiBottomSheet(
                          child: AgentFilterBottomSheet(filter: state.filter),
                        );
                      },
                    );

                    if (result != null) {
                      unawaited(context.read<BotsCubit>().setFilter(result));
                    }
                  },
                  onPressedSort: () {
                    context.read<BotsCubit>().setFilter(
                      state.filter.copyWith(
                        sort: switch (state.filter.sort) {
                          SortType.asc => SortType.desc,
                          SortType.desc => SortType.asc,
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: Insets.l),
                if (state.status.isFetchingInProgress && state.items.isEmpty)
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: context.colors.white100,
                      highlightColor: context.colors.background,
                      child: UiCard(
                        borderRadius: BorderRadius.circular(Insets.xl),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SwipeRefresh.builder(
                      stateStream: _controller.stream,
                      onRefresh: context.read<BotsCubit>().init,
                      itemCount: state.filteredItems.length,
                      itemBuilder: (context, index) {
                        final filteredItems = state.filteredItems;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  state.filteredItems.last !=
                                          state.filteredItems[index]
                                      ? const BorderSide(
                                        color: Color(0xFFE9E9F8),
                                      )
                                      : BorderSide.none,
                            ),
                            borderRadius:
                                index == 0
                                    ? const BorderRadius.only(
                                      topLeft: Radius.circular(Insets.xl),
                                      topRight: Radius.circular(Insets.xl),
                                    )
                                    : null,
                            color: context.colors.white100,
                          ),
                          child: BotCard(
                            user: state.user,
                            bot: filteredItems[index],
                            onPressedSettings: () async {
                              final result = await showModalBottomSheet<
                                List<MobilePushConfigSettings>
                              >(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: context.colors.white100,
                                useRootNavigator: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(Insets.xl),
                                  ),
                                ),
                                builder: (context) {
                                  return UiBottomSheet(
                                    child: AgentSettingsBottomSheet(
                                      user: state.user!,
                                      botId: filteredItems[index].id,
                                    ),
                                  );
                                },
                              );

                              if (result != null) {
                                unawaited(
                                  context.read<BotsCubit>().setNotifications(
                                    filteredItems[index].id,
                                    result,
                                  ),
                                );
                              }
                            },
                            onPressedDashboard: () {
                              context.read<DashboardCubit>().setAgentFilter(
                                DashboardAgentFilter(
                                  bots: [filteredItems[index]],
                                ),
                              );
                              context.router.parent()?.navigate(
                                const AnalyticsRoute(),
                              );
                            },
                            onPressedSessions: () {
                              context.read<SessionsCubit>().setFilter(
                                SessionFilter(bot: filteredItems[index]),
                              );
                              context.router.parent()?.navigate(
                                const SessionsRoute(),
                              );
                            },
                            onPressedStart: () {},
                            onPressedStop: () {},
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: Insets.bottomNavBar),
              ],
            ),
          ),
        );
      },
    );
  }
}
