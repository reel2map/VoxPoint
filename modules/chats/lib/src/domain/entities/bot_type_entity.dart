import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_type_entity.freezed.dart';
part 'bot_type_entity.g.dart';

@freezed
class BotTypeEntity with _$BotTypeEntity {
  const factory BotTypeEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
  }) = _BotTypeEntity;

  factory BotTypeEntity.fromJson(Map<String, dynamic> json) =>
      _$BotTypeEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
