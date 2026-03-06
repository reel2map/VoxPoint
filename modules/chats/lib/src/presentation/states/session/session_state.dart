part of 'session_cubit.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    FormControl<String>? messageControl,
    AnchorScrollController? scrollController,
    @Default(FetchStatus.pure) FetchStatus status,
    @Default([]) List<BotEntity> bots,
    SessionEntity? session,
    AuthenticatedUser? user,
    List<LogEntity>? logs,
    String? error,
  }) = _SessionState;

  const SessionState._();

  List<LogEntity>? get sortedLogs => logs
      ?.where(
        (e) =>
            e.role.isAi ||
            e.role.isHuman ||
            e.role.isOperator ||
            e.role.isCopilot,
      )
      .sorted((a, b) => a.timestamp.compareTo(b.timestamp));
}
