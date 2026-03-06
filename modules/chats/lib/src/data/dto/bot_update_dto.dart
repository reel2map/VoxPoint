import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_update_dto.freezed.dart';
part 'bot_update_dto.g.dart';

//TODO: full dto
@freezed
class BotUpdateDto with _$BotUpdateDto {
  const factory BotUpdateDto({
    @JsonKey(name: 'push_notification_config')
    BotPushNotificationConfig? config,
  }) = _BotUpdateDto;

  factory BotUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$BotUpdateDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
