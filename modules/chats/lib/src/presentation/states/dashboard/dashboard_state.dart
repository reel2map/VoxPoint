part of 'dashboard_cubit.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(FetchStatus.pure) FetchStatus status,
    @Default([]) List<BotEntity> bots,
    @Default([]) List<CampaignEntity> campaigns,
    @Default([]) List<DashboardAgentPeriodEntity> agentsPeriods,
    @Default([]) List<DashboardCampaignPeriodEntity> campaignPeriods,
    @Default(DashboardAgentFilter()) DashboardAgentFilter agentFilter,
    @Default(DashboardCampaignFilter()) DashboardCampaignFilter campaignFilter,
    @Default(0) int currentTab,
    String? error,
  }) = _DashboardState;

  const DashboardState._();
}

@freezed
class DashboardAgentFilter with _$DashboardAgentFilter {
  const factory DashboardAgentFilter({
    @Default(PeriodType.week) PeriodType period,
    List<BotEntity>? bots,
  }) = _DashboardAgentFilter;

  const DashboardAgentFilter._();
}

@freezed
class DashboardCampaignFilter with _$DashboardCampaignFilter {
  const factory DashboardCampaignFilter({
    @Default(PeriodType.week) PeriodType period,
    CampaignEntity? campaign,
  }) = _DashboardCampaignFilter;

  const DashboardCampaignFilter._();
}
