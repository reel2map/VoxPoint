import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_status_entity.freezed.dart';
part 'bot_status_entity.g.dart';

@freezed
class BotStatusEntity with _$BotStatusEntity {
  const factory BotStatusEntity({
    @JsonKey(name: 'status', unknownEnumValue: BotStatus.unknown)
    required BotStatus status,
    @JsonKey(name: 'message') String? message,
  }) = _BotStatusEntity;

  factory BotStatusEntity.fromJson(Map<String, dynamic> json) =>
      _$BotStatusEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum BotStatus {
  @JsonValue('STOPPED')
  stopped,
  @JsonValue('RUNNING')
  running,
  @JsonValue('STOPPING')
  stopping,
  @JsonValue('STARTING')
  starting,
  @JsonValue('ERROR')
  error,
  @JsonValue('UNKNOWN')
  unknown,
}
