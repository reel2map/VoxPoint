part of 'support_chat_cubit.dart';

@freezed
abstract class SupportChatState with _$SupportChatState {
  const factory SupportChatState({
    required String botId,
    required String token,
    String? error,
    @Default(FetchStatus.pure) FetchStatus status,
  }) = _SupportChatState;

  const SupportChatState._();
}
