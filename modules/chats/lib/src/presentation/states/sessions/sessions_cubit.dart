import 'dart:async';

import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'sessions_cubit.freezed.dart';
part 'sessions_state.dart';

@injectable
class SessionsCubit extends BaseCubit<SessionsState> {
  SessionsCubit(this._sessionsRepository, this._authManager, this._eventBus)
    : super(SessionsState(searchControl: FormControl<String>())) {
    init();
  }

  final AuthManager<UserEntity> _authManager;

  final SessionsRepository _sessionsRepository;

  final EventBus _eventBus;

  StreamSubscription<SessionCreatedEvent>? _sessionCreatedSubscription;

  StreamSubscription<SessionClosedEvent>? _sessionClosedSubscription;

  StreamSubscription<SessionUpdatedEvent>? _sessionUpdatedSubscription;

  StreamSubscription<String?>? _streamSubscription;

  static const int _limit = 50;

  Future<void> init() async {
    _streamSubscription ??= state.searchControl.valueChanges
        .debounceTime(const Duration(seconds: 1))
        .listen((value) {
          emit(
            state.copyWith(filter: state.filter.copyWith(userSearch: value)),
          );

          if ((value == null) || value.isEmpty || value.length > 2) {
            init();
          }
        });

    _sessionCreatedSubscription ??= _eventBus.on<SessionCreatedEvent>().listen(
      _onSessionCreated,
    );

    _sessionClosedSubscription ??= _eventBus.on<SessionClosedEvent>().listen(
      _onSessionClosed,
    );

    _sessionUpdatedSubscription ??= _eventBus.on<SessionUpdatedEvent>().listen(
      _onSessionUpdated,
    );

    emit(state.copyWith(status: FetchStatus.fetchingInProgress, page: 1));

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final result = await Future.wait([
      _sessionsRepository.getSessions(
        tenantId: tenantId ?? '',
        limit: _limit,
        skip: (state.page - 1) * _limit,
        filter: state.filter,
      ),
      _sessionsRepository.getSessionUsers(tenantId: tenantId ?? ''),
    ]);

    result.first.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (sessions) {
        if (sessions.isEmpty) {
          emit(
            state.copyWith(
              status: FetchStatus.fetchingSuccess,
              hasMore: false,
              items: sessions as List<SessionEntity>,
              users:
                  result.last.getRight() as List<SessionUserEntity>? ??
                  <SessionUserEntity>[],
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: FetchStatus.fetchingSuccess,
            items: sessions as List<SessionEntity>,
            users:
                result.last.getRight() as List<SessionUserEntity>? ??
                <SessionUserEntity>[],
          ),
        );

        _addBots();
      },
    );
  }

  void _onSessionCreated(SessionCreatedEvent event) {
    final session = event.data.copyWith(
      bot: state.bots.firstWhereOrNull((bot) => bot.id == event.data.botId),
    );

    if (_checkFilter(session)) {
      emit(state.copyWith(items: [session, ...state.items]));
    }
  }

  void _onSessionClosed(SessionClosedEvent event) {
    final session = event.data.copyWith(
      bot: state.bots.firstWhereOrNull((bot) => bot.id == event.data.botId),
    );

    final sessions =
        state.items.map((e) {
          if (e.id == event.data.id) {
            return session;
          } else {
            return e;
          }
        }).toList();

    emit(state.copyWith(items: sessions));
  }

  void _onSessionUpdated(SessionUpdatedEvent event) {
    final session = event.data.copyWith(
      bot: state.bots.firstWhereOrNull((bot) => bot.id == event.data.botId),
    );

    final sessions =
        state.items.map((e) {
          if (e.id == event.data.id) {
            return session;
          } else {
            return e;
          }
        }).toList();

    emit(state.copyWith(items: sessions));
  }

  bool _checkFilter(SessionEntity session) {
    var result = true;

    if (state.filter.bot != null) {
      result = session.botId == state.filter.bot?.id;
    }

    if (state.filter.userType != null && result) {
      result = state.filter.userType == session.user.type;
    }

    return result;
  }

  Future<void> nextPage() async {
    if (state.status.isFetchingInProgress) return;

    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final page = state.page + 1;

    final result = await _sessionsRepository.getSessions(
      tenantId: tenantId ?? '',
      limit: _limit,
      skip: (page - 1) * _limit,
      filter: state.filter,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (sessions) {
        if (sessions.isEmpty) {
          emit(
            state.copyWith(status: FetchStatus.fetchingSuccess, hasMore: false),
          );
          return;
        }

        final result = [...state.items, ...sessions].unique((e) => e.id);

        emit(
          state.copyWith(
            status: FetchStatus.fetchingSuccess,
            items: result,
            page: page,
          ),
        );

        _addBots();
      },
    );
  }

  Future<void> setBots(List<BotEntity> bots) async {
    emit(state.copyWith(bots: bots));
    _addBots();
  }

  void _addBots() {
    final sessions =
        state.items
            .map(
              (e) => e.copyWith(
                bot: state.bots.firstWhereOrNull((bot) => bot.id == e.botId),
              ),
            )
            .toList();

    emit(state.copyWith(items: sessions));
  }

  Future<void> setFilter(SessionFilter filter) async {
    emit(state.copyWith(filter: filter));

    await init();
  }

  @override
  Future<void> close() async {
    await _sessionCreatedSubscription?.cancel();

    await _sessionClosedSubscription?.cancel();

    await _sessionUpdatedSubscription?.cancel();

    await _streamSubscription?.cancel();

    await super.close();
  }
}
