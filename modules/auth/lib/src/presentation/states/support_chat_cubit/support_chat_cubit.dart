import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'support_chat_cubit.freezed.dart';
part 'support_chat_state.dart';

@injectable
class SupportChatCubit extends BaseCubit<SupportChatState> {
  SupportChatCubit({required BotRepository botRepository})
    : _botRepository = botRepository,
      super(
        const SupportChatState(
          botId: '',
          token: '',
          status: FetchStatus.fetchingInProgress,
        ),
      ) {
    init();
  }

  final BotRepository _botRepository;

  Future<void> init() async {
    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final result = await _botRepository.getSupportBot();

    result.fold(
      (failure) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (bot) {
        emit(
          state.copyWith(
            status: FetchStatus.fetchingSuccess,
            botId: bot.id,
            token: bot.token,
          ),
        );
      },
    );
  }
}
