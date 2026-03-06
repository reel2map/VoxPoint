import 'dart:async';

import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AgentsDashboard extends StatelessWidget {
  const AgentsDashboard({required this.state, super.key});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
          child: DashboardAgentAppBar(
            filter: state.agentFilter,
            onPressedBotFilter: () async {
              final result = await showModalBottomSheet<DashboardAgentFilter>(
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
                    heightFactor: 0.9,
                    child: AnalyticsBotBottomSheet(
                      filter: state.agentFilter,
                      bots: state.bots,
                    ),
                  );
                },
              );

              if (result != null) {
                unawaited(
                  context.read<DashboardCubit>().setAgentFilter(result),
                );
              }
            },
            onPressedPeriodFilter: () async {
              final result = await showModalBottomSheet<PeriodType>(
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
                    child: AnalyticsPeriodBottomSheet(
                      period: state.agentFilter.period,
                    ),
                  );
                },
              );

              if (result != null) {
                unawaited(
                  context.read<DashboardCubit>().setAgentFilter(
                    state.agentFilter.copyWith(period: result),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: Insets.l),
        if (state.status.isFetchingInProgress && state.agentsPeriods.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 2 * Insets.xxxl),
            child: Center(child: UiProgressIndicator()),
          )
        else if (state.status.isFetchingFailure)
          Padding(
            padding: const EdgeInsets.only(top: 2 * Insets.xxxl),
            child: Center(
              child: Text(
                ChatsI18n.unknownError,
                style: context.texts.title.copyWith(
                  color: context.colors.mediumGrey,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Insets.xl),
                topRight: Radius.circular(Insets.xl),
              ),
              color: context.colors.white100,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: TotalSessionVolumeChart(
                    periods: state.agentsPeriods,
                    period: state.agentFilter.period,
                  ),
                ),
                Divider(height: 1, color: context.colors.extraLightGrey),
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: TotalUniqueUserCountChart(
                    periods: state.agentsPeriods,
                    period: state.agentFilter.period,
                  ),
                ),
                Divider(height: 1, color: context.colors.extraLightGrey),
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: OperatorSessionBreakdownChart(
                    periods: state.agentsPeriods,
                    period: state.agentFilter.period,
                  ),
                ),
                Divider(height: 1, color: context.colors.extraLightGrey),
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: AverageMessageVolumePerSessionChart(
                    periods: state.agentsPeriods,
                    period: state.agentFilter.period,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: Insets.bottomNavBar),
      ],
    );
  }
}
