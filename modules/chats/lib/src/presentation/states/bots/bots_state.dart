part of 'bots_cubit.dart';

@freezed
class BotsState with _$BotsState {
  const factory BotsState({
    required FormControl<String> searchControl,
    AuthenticatedUser? user,
    @Default(FetchStatus.pure) FetchStatus status,
    @Default([]) List<BotEntity> items,
    @Default(BotFilter()) BotFilter filter,
    String? error,
  }) = _BotsState;

  const BotsState._();

  List<BotEntity> get filteredItems {
    var results = <BotEntity>[...items];

    if (filter.text?.isNotEmpty ?? true) {
      results =
          results
              .where(
                (e) => e.name.toLowerCase().contains(
                  filter.text?.toLowerCase() ?? '',
                ),
              )
              .toList();
    }

    if (filter.statuses.isNotEmpty) {
      results =
          results
              .where((e) => filter.statuses.contains(e.status.status))
              .toList();
    }

    return switch (filter.sort) {
      SortType.asc => results.sorted(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ),
      SortType.desc => results.sorted(
        (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      ),
    };
  }
}
