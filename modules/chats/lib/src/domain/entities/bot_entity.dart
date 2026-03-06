import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_entity.freezed.dart';
part 'bot_entity.g.dart';

@freezed
class BotEntity with _$BotEntity {
  const factory BotEntity({
    @JsonKey(name: 'created_on') required DateTime createdOn,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'modified_on') required DateTime modifiedOn,
    @JsonKey(name: 'modified_by') required String modifiedBy,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'status') required BotStatusEntity status,
    @JsonKey(name: 'language') required String language,
    @JsonKey(name: 'bot_type') required BotTypeEntity botType,
    @JsonKey(name: 'prompts') required List<PromptEntity> prompts,
    @JsonKey(name: 'skills') required List<SkillEntity> skills,
    @JsonKey(name: 'channels') required List<ChannelEntity> channels,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'flow', unknownEnumValue: BotFlow.unknown) BotFlow? flow,
    @JsonKey(name: 'route') String? route,
    @JsonKey(name: 'public_route') String? publicRoute,
    @JsonKey(name: 'kbs') BotKnowledgeBaseV2Model? kbs,
    @JsonKey(name: 'identity') String? identity,
    @JsonKey(name: 'speech_style') String? speechStyle,
    @JsonKey(name: 'default_operator') String? defaultOperator,
    @JsonKey(name: 'receptionist_agent_task') String? receptionistAgentTask,
    @JsonKey(name: 'max_opened_sessions') int? maxOpenedSessions,
    @JsonKey(name: 'interviewer_agent_task') String? interviewerAgentTask,
    @JsonKey(name: 'custom_agent_task') String? customAgentTask,
    @JsonKey(name: 'fast_rag') String? fastRag,
    @JsonKey(name: 'workflow') String? workflow,
    @JsonKey(name: 'data_model') String? dataModel,
    @JsonKey(name: 'show_rag_sources') bool? showRagSource,
    @JsonKey(name: 'show_waiting_phrases') bool? showWaitingPhrases,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'widget_settings') Map<String, dynamic>? widgetSettings,
    @JsonKey(name: 'schedule') Map<String, dynamic>? schedule,
    @Default([])
    @JsonKey(name: 'integrations')
    List<IntegrationEntity> integrations,
    @JsonKey(name: 'push_notification_config')
    BotPushNotificationConfig? pushNotificationConfig,
  }) = _BotEntity;

  factory BotEntity.fromJson(Map<String, dynamic> json) =>
      _$BotEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum BotFlow {
  @JsonValue('INBOUND')
  inbound,
  @JsonValue('OUTBOUND')
  outbound,
  @JsonValue('CUSTOM')
  custom,
  @JsonValue('EXTERNAL')
  external,
  @JsonValue('CUSTOM_STATEFUL')
  customStateful,
  @JsonValue('FAST_VOICE_AGENT')
  fastVoiceAgent,
  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
class BotKnowledgeBaseV2Model with _$BotKnowledgeBaseV2Model {
  const factory BotKnowledgeBaseV2Model({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
  }) = _BotKnowledgeBaseV2Model;

  factory BotKnowledgeBaseV2Model.fromJson(Map<String, dynamic> json) =>
      _$BotKnowledgeBaseV2ModelFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class BotPushNotificationConfig with _$BotPushNotificationConfig {
  const factory BotPushNotificationConfig({
    required String url,
    @Default(false) @JsonKey(name: 'enabled') bool enabled,
    @Default([]) List<MobilePushConfigSettings> events,
    List<BotPushNotificationHeader>? headers,
  }) = _BotPushNotificationConfig;

  factory BotPushNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$BotPushNotificationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class BotPushNotificationHeader with _$BotPushNotificationHeader {
  const factory BotPushNotificationHeader({
    required String name,
    required String value,
    bool? isSecret,
  }) = _BotPushNotificationHeader;

  factory BotPushNotificationHeader.fromJson(Map<String, dynamic> json) =>
      _$BotPushNotificationHeaderFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
