import 'dart:async';

import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'dashboard_cubit.freezed.dart';
part 'dashboard_state.dart';

@injectable
class DashboardCubit extends BaseCubit<DashboardState> {
  DashboardCubit(this._sessionsRepository, this._authManager)
    : super(const DashboardState()) {
    init();
  }

  final AuthManager<UserEntity> _authManager;

  final SessionsRepository _sessionsRepository;

  Future<void> init() async {
    if (state.status.isFetchingInProgress) return;

    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final result = await Future.wait([
      _sessionsRepository.getAgentsDashboard(
        tenantId: tenantId ?? '',
        period: state.agentFilter.period,
        botIds: state.agentFilter.bots?.map((e) => e.id).toList(),
      ),
      _sessionsRepository.getCampaigns(tenantId: tenantId ?? ''),
    ]);

    result.first.fold(
      (failure) => emit(
        state.copyWith(
          status: FetchStatus.fetchingFailure,
          error: failure.getLocalizedString(),
          agentsPeriods: [],
        ),
      ),
      (periods) {
        emit(
          state.copyWith(
            status: FetchStatus.fetchingSuccess,
            agentsPeriods: periods as List<DashboardAgentPeriodEntity>,
            campaigns: (result.last.getRight() as List<CampaignEntity>?) ?? [],
          ),
        );
      },
    );
  }

  Future<void> setBots(List<BotEntity> bots) async {
    emit(state.copyWith(bots: bots));
  }

  Future<void> setAgentFilter(DashboardAgentFilter filter) async {
    setTab(0);

    emit(state.copyWith(agentFilter: filter));

    await init();
  }

  void setTab(int index) {
    emit(state.copyWith(currentTab: index));
  }

  Future<void> setCampaignFilter(DashboardCampaignFilter filter) async {
    setTab(1);
    emit(state.copyWith(campaignFilter: filter));

    if (filter.campaign != null) {
      emit(state.copyWith(status: FetchStatus.fetchingInProgress));

      final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

      final result = await _sessionsRepository.getCampaignDashboard(
        tenantId: tenantId ?? '',
        period: state.campaignFilter.period,
        campaignId: state.campaignFilter.campaign?.id ?? '',
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FetchStatus.fetchingFailure,
              campaignPeriods: [],
            ),
          );
        },
        (periods) {
          emit(
            state.copyWith(
              status: FetchStatus.fetchingSuccess,
              campaignPeriods: periods,
            ),
          );
        },
      );

      unawaited(init());
    }
  }
}
