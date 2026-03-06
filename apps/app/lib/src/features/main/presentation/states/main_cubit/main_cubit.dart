import 'dart:async';

import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'main_cubit.freezed.dart';
part 'main_state.dart';

@injectable
class MainCubit extends BaseCubit<MainState> {
  MainCubit({required EventBus eventBus})
    : _eventBus = eventBus,
      super(const MainState());

  final EventBus _eventBus;

  Future<void> init() async {
    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    emit(state.copyWith(status: FetchStatus.fetchingSuccess, isDemo: true));
  }

  void redirect(Map<String, dynamic> data) {
    //TODO: check

    final type = data['event_type'] as String?;

    switch (type) {
      case 'new_session':
      case 'message_from_human':
      case 'transferred_to_operator':
        if (data['session_id'] != null) {
          final String? sessionId = data['session_id'] as String?;

          emit(
            state.copyWith(
              redirectPage: SessionsRootRouter(
                children: [SessionRoute(id: sessionId ?? '')],
              ),
            ),
          );

          Future<void>.delayed(const Duration(milliseconds: 300), () {
            emit(state.copyWith(redirectPage: null));
          });
        }
      case 'message_from_ai':
      case null:
      default:
        if (data['session_id'] != null) {
          final String? sessionId = data['session_id'] as String?;

          emit(
            state.copyWith(redirectPage: ChatRootRouter(sessionId: sessionId)),
          );

          Future<void>.delayed(const Duration(milliseconds: 300), () {
            emit(state.copyWith(redirectPage: null));
          });
        }
    }
  }

  @override
  Future<void> close() {
    // _eventBus
    return super.close();
  }
}
