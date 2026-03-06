import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_bot_entity.freezed.dart';
part 'support_bot_entity.g.dart';

@freezed
class SupportBotEntity with _$SupportBotEntity {
  const factory SupportBotEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'token') required String token,
  }) = _SupportBotEntity;

  factory SupportBotEntity.fromJson(Map<String, dynamic> json) =>
      _$SupportBotEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
