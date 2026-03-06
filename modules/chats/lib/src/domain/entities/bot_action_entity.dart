import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_action_entity.freezed.dart';
part 'bot_action_entity.g.dart';

@freezed
class BotActionEntity with _$BotActionEntity {
  const factory BotActionEntity({
    @JsonKey(name: 'action') required BotAction action,
  }) = _BotActionEntity;

  factory BotActionEntity.fromJson(Map<String, dynamic> json) =>
      _$BotActionEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum BotAction {
  @JsonValue('START')
  start,
  @JsonValue('STOP')
  stop,
  @JsonValue('STATUS')
  status,
}
