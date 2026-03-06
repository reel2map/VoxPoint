import 'dart:async';

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

part 'session_cubit.freezed.dart';
part 'session_state.dart';

@injectable
class SessionCubit extends BaseCubit<SessionState> {
  SessionCubit(this._sessionsRepository, this._authManager, this._eventBus)
    : super(SessionState(messageControl: FormControl<String>()));

  final AuthManager<UserEntity> _authManager;

  final SessionsRepository _sessionsRepository;

  final EventBus _eventBus;

  StreamSubscription<SessionClosedEvent>? _sessionClosedSubscription;

  StreamSubscription<SessionUpdatedEvent>? _sessionUpdatedSubscription;

  StreamSubscription<SessionNewMessageEvent>? _sessionNewMessageSubscription;

  StreamSubscription<SessionMessageModifiedEvent>?
  _sessionMessageModifiedSubscription;

  StreamSubscription<SessionMovedToOperatorEvent>? _sessionMovedToOperatorEvent;

  StreamSubscription<UserEntity>? _userSubscription;

  Future<void> init(String id, List<BotEntity> bots) async {
    if (state.scrollController == null) {
      emit(
        state.copyWith(
          scrollController: AnchorScrollController(
            /*  onAttach: (position) {
              _scrollDownList();
            },*/
          ),
        ),
      );
    }

    emit(state.copyWith(user: _authManager.user.value.authenticatedOrNull));

    _userSubscription ??= _authManager.user.listen(_updateUser);

    _sessionClosedSubscription ??= _eventBus.on<SessionClosedEvent>().listen(
      _onSessionClosed,
    );

    _sessionUpdatedSubscription ??= _eventBus.on<SessionUpdatedEvent>().listen(
      _onSessionUpdated,
    );

    _sessionNewMessageSubscription ??= _eventBus
        .on<SessionNewMessageEvent>()
        .listen(_onSessionNewMessage);

    _sessionMessageModifiedSubscription ??= _eventBus
        .on<SessionMessageModifiedEvent>()
        .listen(_onSessionMessageModified);

    _sessionMovedToOperatorEvent ??= _eventBus
        .on<SessionMovedToOperatorEvent>()
        .listen(_onSessionMovedToOperatorEvent);

    emit(state.copyWith(status: FetchStatus.firstFetchingInProgress));

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final result = await _sessionsRepository.getSession(
      tenantId: tenantId ?? '',
      sessionId: id,
    );

    unawaited(
      _sessionsRepository
          .getSessionLogs(tenantId: tenantId ?? '', sessionId: id)
          .then((result) {
            emit(state.copyWith(logs: result.getRight() ?? []));
            _scrollDownList();
          }),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure, bots: bots));
      },
      (session) {
        emit(
          state.copyWith(
            status: FetchStatus.fetchingSuccess,
            session: session,
            bots: bots,
          ),
        );

        _addBot();
      },
    );
  }

  void _updateUser(UserEntity user) {
    emit(state.copyWith(user: user.authenticatedOrNull));
  }

  Future<void> resolve() async {
    final isConfirm = await DialogService.showModalBottomSheet<bool>(
      barrierColor: Colors.transparent,
      child: SessionResolveConfirmBottomSheet(
        title: ChatsI18n.confirm,
        description: ChatsI18n.confirmDescription,
      ),
    );

    if (isConfirm ?? false) {
      final result = await _sessionsRepository.resolve(
        botId: state.session!.botId,
        sessionId: state.session!.id,
        status: 'resolved_by_operator',
      );

      await result.fold((error) {}, (r) async {
        final result = await _sessionsRepository.getSession(
          tenantId: state.user?.tenant?.id ?? '',
          sessionId: state.session!.id,
        );

        result.fold((e) {}, (session) {
          emit(
            state.copyWith(
              status: FetchStatus.fetchingSuccess,
              session: session,
              // bots: bots,
            ),
          );
        });
      });
    }
  }

  Future<void> _scrollDownList() async {
    try {
      await Future<void>.delayed(Durations.short1);

      if (state.scrollController?.hasClients ?? false) {
        await state.scrollController?.animateTo(
          state.scrollController!.position.maxScrollExtent,
          duration: Durations.medium1,
          curve: Curves.easeIn,
        );
      }
    } on Exception catch (_) {}
  }

  void _onSessionClosed(SessionClosedEvent event) {
    if (state.session?.id == event.data.id) {
      emit(state.copyWith(session: event.data));
      _addBot();
    }
  }

  void _onSessionUpdated(SessionUpdatedEvent event) {
    if (state.session?.id == event.data.id &&
        !state.status.isFetchingInProgress) {
      emit(state.copyWith(session: event.data));
      _addBot();
    }
  }

  void _onSessionNewMessage(SessionNewMessageEvent event) {
    if (state.session?.id == event.data.sessionId) {
      emit(state.copyWith(logs: [...state.logs ?? [], event.data]));
    }

    if (event.data.role.isAi ||
        event.data.role.isHuman ||
        event.data.role.isOperator ||
        event.data.role.isCopilot) {
      _scrollDownList();
    }
  }

  void _onSessionMessageModified(SessionMessageModifiedEvent event) {
    if (state.session?.id == event.data.sessionId) {
      final logs =
          state.logs?.map((e) {
            if (e.id == event.data.id) {
              return event.data;
            } else {
              return e;
            }
          }).toList();

      emit(state.copyWith(logs: logs));
    }
  }

  void _onSessionMovedToOperatorEvent(SessionMovedToOperatorEvent event) {
    if (state.session?.id == event.data.id &&
        !state.status.isFetchingInProgress) {
      emit(state.copyWith(session: event.data));
      _addBot();
    }
  }

  Future<void> setBots(List<BotEntity> bots) async {
    emit(state.copyWith(bots: bots));
    await _addBot();
  }

  Future<void> _addBot() async {
    emit(
      state.copyWith(
        session: state.session?.copyWith(
          bot: state.bots.firstWhereOrNull((e) => e.id == state.session?.botId),
        ),
      ),
    );
  }

  Future<void> share() async {
    final buffer = StringBuffer();

    for (final log in state.sortedLogs ?? <LogEntity>[]) {
      buffer
        ..writeln('----------------------')
        ..writeln(log.role.name)
        ..writeln(log.text)
        ..writeln(
          '${DateFormat(DateFormats.ddMMMyyyy).format(log.timestamp)}・${DateFormat(DateFormats.hhmm).format(log.timestamp)}',
        );
    }

    if ((state.sortedLogs ?? []).isNotEmpty) {
      buffer
        ..writeln('----------------------')
        ..writeln();
    }

    if (state.session?.envInfo?.isNotEmpty ?? false) {
      buffer.writeln(ChatsI18n.parameters);
      for (final entry
          in (state.session?.envInfo?.entries ??
              <MapEntry<String, dynamic>>[])) {
        buffer
          ..writeln(entry.key)
          ..writeln(entry.value?.toString() ?? '—')
          ..writeln();
      }
      buffer.writeln();
    }

    if ((state.session?.conversationResult ?? {}).isNotEmpty) {
      buffer.writeln(ChatsI18n.results);
      for (final entry in (state.session?.conversationResult ?? {}).entries) {
        buffer
          ..writeln(entry.key)
          ..writeln(entry.value?.toString() ?? '—')
          ..writeln();
      }

      buffer.writeln();
    }

    unawaited(Share.share(buffer.toString()));
  }

  Future<void> changeMode(SessionType type) async {
    if (state.session?.finishTime != null) return;

    if (state.session?.bot == null) return;

    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final result = await _sessionsRepository.setSessionMode(
      bot: state.session!.bot!,
      tenantId: state.user?.tenant?.id ?? '',
      sessionId: state.session?.id ?? '',
      operatorId: state.user?.id ?? '',
      sessionType: type,
    );

    await result.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (success) async {
        final session = await _sessionsRepository.getSession(
          tenantId: state.user?.tenant?.id ?? '',
          sessionId: state.session?.id ?? '',
        );

        session.fold((failure) {}, (model) {
          emit(
            state.copyWith(session: model, status: FetchStatus.fetchingSuccess),
          );
          _addBot();
        });
      },
    );
  }

  @override
  Future<void> close() async {
    await _sessionClosedSubscription?.cancel();

    await _sessionUpdatedSubscription?.cancel();

    await _sessionNewMessageSubscription?.cancel();

    await _sessionMessageModifiedSubscription?.cancel();

    await _sessionMovedToOperatorEvent?.cancel();

    await _userSubscription?.cancel();

    await super.close();
  }

  Future<void> takeOver() async {
    if (state.session?.finishTime != null) return;

    if (state.session?.bot == null) return;

    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final result = await _sessionsRepository.setSessionMode(
      bot: state.session!.bot!,
      tenantId: state.user?.tenant?.id ?? '',
      sessionId: state.session?.id ?? '',
      operatorId: state.user?.id ?? '',
      sessionType: SessionType.copilot,
    );

    await result.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (success) async {
        emit(
          state.copyWith(session: success, status: FetchStatus.fetchingSuccess),
        );

        await _addBot();
      },
    );
  }

  Future<void> sendLog() async {
    if (state.messageControl?.value?.isEmpty ?? true) {
      return;
    }

    if (state.session?.bot == null) {
      //TODO: получить бота и добавить в стейт
    }

    final result = await _sessionsRepository.sendMessage(
      sessionId: state.session?.id ?? '',
      botId: state.session?.botId ?? '',
      message: state.messageControl?.value ?? '',
      botToken: state.session?.bot?.token ?? '',
    );

    result.fold((failure) {}, (success) {
      state.messageControl?.patchValue(null);
    });
  }
}
