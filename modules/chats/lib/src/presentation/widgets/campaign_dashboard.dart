import 'dart:async';

import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class CampaignDashboard extends StatelessWidget {
  const CampaignDashboard({required this.state, super.key});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
          child: DashboardCampaignAppBar(
            filter: state.campaignFilter,
            onPressedCampaignFilter: () => onPressedPeriodFilter(context),
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
                      period: state.campaignFilter.period,
                    ),
                  );
                },
              );

              if (result != null) {
                unawaited(
                  context.read<DashboardCubit>().setCampaignFilter(
                    state.campaignFilter.copyWith(period: result),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: Insets.l),
        if (state.status.isFetchingInProgress && state.campaignPeriods.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 2 * Insets.xxxl),
            child: Center(child: UiProgressIndicator()),
          )
        else if (state.campaignFilter.campaign == null)
          Padding(
            padding: const EdgeInsets.only(top: 2 * Insets.xxxl),
            child: Center(
              child: Column(
                children: [
                  Text(
                    ChatsI18n.selectCampaign,
                    style: context.texts.title.copyWith(
                      color: context.colors.mediumGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onPressedPeriodFilter(context),
                    child: Text(
                      'here',
                      style: context.texts.title.copyWith(
                        color: context.colors.mainOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  child: StatusDistributionChart(
                    period: state.campaignFilter.period,
                    periods: state.campaignPeriods,
                  ),
                ),
                Divider(height: 1, color: context.colors.extraLightGrey),
                Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: StageDistributionChart(
                    periods: state.campaignPeriods,
                    period: state.campaignFilter.period,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: Insets.bottomNavBar),
      ],
    );
  }

  Future<void> onPressedPeriodFilter(BuildContext context) async {
    final result = await showModalBottomSheet<DashboardCampaignFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.white100,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Insets.xl)),
      ),
      builder: (context) {
        return UiBottomSheet(
          heightFactor: 0.9,
          child: AnalyticsCampaignBottomSheet(
            filter: state.campaignFilter,
            campaigns: state.campaigns,
          ),
        );
      },
    );

    if (result != null) {
      unawaited(context.read<DashboardCubit>().setCampaignFilter(result));
    }
  }
}
