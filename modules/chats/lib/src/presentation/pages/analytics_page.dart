import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final StreamController<SwipeRefreshState> _controller =
      StreamController.broadcast();

  @override
  void initState() {
    context.read<DashboardCubit>().setBots(
      context.read<BotsCubit>().state.items,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocListener<BotsCubit, BotsState>(
        listener: (context, state) {
          context.read<DashboardCubit>().setBots(state.items);
        },
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state.status.isFetchingInProgress) {
              _controller.add(SwipeRefreshState.loading);
            } else {
              _controller.add(SwipeRefreshState.hidden);
            }
            if (state.currentTab != DefaultTabController.of(context).index) {
              DefaultTabController.of(context).animateTo(state.currentTab);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const DashboardTabBar(),
                // actions: [
                //   IconButton(
                //     onPressed: () async {
                //       GetIt.I<SettingsCubit>().emit(
                //         GetIt.I<SettingsCubit>().state.copyWith(
                //           pushNotificationData: {
                //             'session_id':
                //                 '0684149c-44ce-7e2e-8000-391fa21ccaef',
                //           },
                //         ),
                //       );

                //       await Future.delayed(const Duration(milliseconds: 300));
                //       GetIt.I<SettingsCubit>().emit(
                //         GetIt.I<SettingsCubit>().state.copyWith(
                //           pushNotificationData: null,
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.dangerous),
                //   ),
                // ],
              ),
              resizeToAvoidBottomInset: false,
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SwipeRefresh.adaptive(
                    stateStream: _controller.stream,
                    onRefresh: context.read<DashboardCubit>().init,
                    children: [AgentsDashboard(state: state)],
                  ),
                  SwipeRefresh.adaptive(
                    stateStream: _controller.stream,
                    onRefresh:
                        () => context.read<DashboardCubit>().setCampaignFilter(
                          state.campaignFilter,
                        ),
                    children: [CampaignDashboard(state: state)],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
