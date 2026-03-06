import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_entity.freezed.dart';
part 'session_entity.g.dart';

enum SessionType {
  @JsonValue('REGULAR')
  regular,
  @JsonValue('OPERATOR')
  operator,
  @JsonValue('COPILOT')
  copilot,
  @JsonValue('unknown')
  unknown;

  bool get isOperator => this == operator;

  bool get isRegular => this == regular;

  bool get isCopilot => this == copilot;

  bool get isUnknown => this == unknown;
}

enum SessionStatus {
  @JsonValue('completed')
  completed,
  @JsonValue('busy')
  busy,
  @JsonValue('noanswer')
  noanswer,
  @JsonValue('canceled')
  canceled,
  @JsonValue('failed')
  failed,
  @JsonValue('resolved_by_operator')
  resolvedByOperator,
  @JsonValue('declined')
  declined,
  @JsonValue('not_found')
  notFound,
  @JsonValue('network_error')
  networkError,
  @JsonValue('unknown')
  unknown,
}

@freezed
class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'bot_id') required String botId,
    @JsonKey(name: 'user') required SessionUserEntity user,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'logs_count') required int logsCount,
    @JsonKey(name: 'offensive_count') required int offensiveCount,
    @JsonKey(name: 'unread_messages_count') required int unreadMessagesCount,
    @JsonKey(name: 'session_type', unknownEnumValue: SessionType.unknown)
    required SessionType sessionType,
    @JsonKey(name: 'bot') BotEntity? bot,
    @JsonKey(name: 'conversation_id') String? conversationId,
    @JsonKey(name: 'last_message_time') DateTime? lastMessageTime,
    @JsonKey(name: 'conversation_result')
    Map<String, dynamic>? conversationResult,
    @JsonKey(name: 'statistics') Map<String, dynamic>? statistics,
    @JsonKey(name: 'user_info') Map<String, dynamic>? userInfo,
    @JsonKey(name: 'env_info') Map<String, dynamic>? envInfo,
    @JsonKey(name: 'contact') SessionContactEntity? contact,
    @JsonKey(name: 'finish_time') DateTime? finishTime,
    @JsonKey(name: 'operator_id') String? operatorId,
    @JsonKey(name: 'status', unknownEnumValue: SessionStatus.unknown)
    SessionStatus? status,
  }) = _SessionEntity;

  factory SessionEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
