import 'dart:async';

import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

part 'bots_cubit.freezed.dart';
part 'bots_state.dart';

@injectable
class BotsCubit extends BaseCubit<BotsState> {
  BotsCubit(
    this._botRepository,
    this._authManager,
    this._eventBus,
    this._settingsRepository,
  ) : super(BotsState(searchControl: FormControl<String>())) {
    init();
  }

  final AuthManager<UserEntity> _authManager;

  final BotRepository _botRepository;

  final SettingsRepository _settingsRepository;

  StreamSubscription<String?>? _searchSubscription;

  StreamSubscription<BotCreatedEvent>? _botCreatedSubscription;

  StreamSubscription<BotModifiedEvent>? _botModifiedSubscription;

  StreamSubscription<BotStatusModifiedEvent>? _botStatusModifiedSubscription;

  StreamSubscription<UserEntity>? _userSubscription;

  final EventBus _eventBus;

  Future<void> init() async {
    _botCreatedSubscription ??= _eventBus.on<BotCreatedEvent>().listen(
      _onBotCreated,
    );

    _botModifiedSubscription ??= _eventBus.on<BotModifiedEvent>().listen(
      _onBotModified,
    );

    _botStatusModifiedSubscription ??= _eventBus
        .on<BotStatusModifiedEvent>()
        .listen(_onBotStatusModified);

    _searchSubscription ??= state.searchControl.valueChanges
        .debounceTime(Durations.medium2)
        .listen((value) => setFilter(state.filter.copyWith(text: value)));

    emit(
      state.copyWith(
        status: FetchStatus.fetchingInProgress,
        user: _authManager.user.value.authenticatedOrNull,
      ),
    );

    _userSubscription ??= _authManager.user.listen(_updateUser);

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final result = await _botRepository.getBots(tenantId: tenantId);

    result.fold(
      (failure) => emit(state.copyWith(status: FetchStatus.fetchingFailure)),
      (items) {
        emit(state.copyWith(status: FetchStatus.fetchingSuccess, items: items));
      },
    );
  }

  void _updateUser(UserEntity user) {
    emit(state.copyWith(user: user.authenticatedOrNull));
  }

  Future<void> _onBotCreated(BotCreatedEvent event) async {
    emit(state.copyWith(items: [...state.items, event.data]));
  }

  Future<void> _onBotModified(BotModifiedEvent event) async {
    final newBots =
        state.items.map((e) {
          if (e.id == event.data.id) {
            return event.data;
          } else {
            return e;
          }
        }).toList();

    emit(state.copyWith(items: newBots));
  }

  Future<void> _onBotStatusModified(BotStatusModifiedEvent event) async {
    final newBots =
        state.items.map((e) {
          if (e.id == event.data.id) {
            return event.data;
          } else {
            return e;
          }
        }).toList();

    emit(state.copyWith(items: newBots));
  }

  Future<void> setFilter(BotFilter filter) async {
    emit(state.copyWith(filter: filter));
  }

  Future<void> startBot(String botId) async {
    final isConfirm = await DialogService.showModalBottomSheet<bool>(
      barrierColor: Colors.transparent,
      child: AgentActionConfirmBottomSheet(
        title: ChatsI18n.startingAgent,
        description: ChatsI18n.startingAgentDescription,
      ),
    );

    if (!(isConfirm ?? false)) return;

    final result = await _botRepository.action(
      botId: botId,
      action: const BotActionEntity(action: BotAction.start),
    );

    result.fold((failure) {}, (status) {
      emit(
        state.copyWith(
          items:
              state.items
                  .map((e) => e.id == botId ? e.copyWith(status: status) : e)
                  .toList(),
        ),
      );
    });
  }

  Future<void> stopBot(String botId) async {
    final isConfirm = await DialogService.showModalBottomSheet<bool>(
      barrierColor: Colors.transparent,
      child: AgentActionConfirmBottomSheet(
        title: ChatsI18n.stoppingAgent,
        description: ChatsI18n.stoppingAgentDescription,
      ),
    );

    if (!(isConfirm ?? false)) return;

    final result = await _botRepository.action(
      botId: botId,
      action: const BotActionEntity(action: BotAction.stop),
    );

    result.fold((failure) {}, (status) {
      emit(
        state.copyWith(
          items:
              state.items
                  .map((e) => e.id == botId ? e.copyWith(status: status) : e)
                  .toList(),
        ),
      );
    });
  }

  Future<void> setNotifications(
    String botId,
    List<MobilePushConfigSettings> events,
  ) async {
    final config =
        state.user?.mobilePushConfig ??
        const MobilePushConfig(systemEnabled: true, agentsEnabled: true);

    final subscription = config.subscriptions.firstWhereOrNull(
      (e) => e.botId == botId,
    );

    final newSubscriptions = [...config.subscriptions];

    if (subscription == null) {
      newSubscriptions.add(BotSubscription(botId: botId, events: events));
    } else {
      newSubscriptions
        ..remove(subscription)
        ..add(BotSubscription(botId: botId, events: events));
    }

    await _settingsRepository.setPushSettings(
      config.copyWith(subscriptions: newSubscriptions),
    );

    unawaited(_authManager.verify());
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    _botCreatedSubscription?.cancel();
    _botModifiedSubscription?.cancel();
    _botStatusModifiedSubscription?.cancel();
    _userSubscription?.cancel();

    return super.close();
  }
}
