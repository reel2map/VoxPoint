part of 'sessions_cubit.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState({
    required FormControl<String> searchControl,
    @Default([]) List<BotEntity> bots,
    @Default(FetchStatus.pure) FetchStatus status,
    @Default([]) List<SessionEntity> items,
    @Default([]) List<SessionUserEntity> users,
    @Default(SessionFilter()) SessionFilter filter,
    String? error,
    @Default(1) int page,
    @Default(true) bool hasMore,
  }) = _SessionsState;

  const SessionsState._();
}
