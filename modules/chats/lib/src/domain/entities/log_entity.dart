import 'package:chats/src/domain/entities/log_attachment_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entity.freezed.dart';
part 'log_entity.g.dart';

@freezed
class LogEntity with _$LogEntity {
  const factory LogEntity({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'timestamp') required DateTime timestamp,
    @JsonKey(name: 'role', unknownEnumValue: LogRole.unknown)
    required LogRole role,
    @JsonKey(name: 'is_offensive') required bool isOffensive,
    @JsonKey(name: 'text') required String text,
    /*
     session_id only on websocket
    */
    @JsonKey(name: 'session_id') String? sessionId,
    @JsonKey(name: 'meta') Map<String, dynamic>? meta,
    @Default([])
    @JsonKey(name: 'attachments')
    List<LogAttachmentEntity> attachments,
  }) = _LogEntity;

  factory LogEntity.fromJson(Map<String, dynamic> json) =>
      _$LogEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum LogRole {
  @JsonValue('HUMAN')
  human,
  @JsonValue('AI')
  ai,
  @JsonValue('OPERATOR')
  operator,
  @JsonValue('COPILOT')
  copilot,
  @JsonValue('NOTES')
  notes,
  @JsonValue('unknown')
  unknown;

  bool get isAi => this == ai;

  bool get isHuman => this == human;

  bool get isOperator => this == operator;

  bool get isCopilot => this == copilot;

  bool get isNotes => this == notes;
}
