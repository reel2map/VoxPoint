import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'integration_entity.freezed.dart';
part 'integration_entity.g.dart';

@freezed
class IntegrationEntity with _$IntegrationEntity {
  const factory IntegrationEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'itype_id') required String iTypeId,
    @JsonKey(name: 'urls') required List<UrlEntity> urls,
    @JsonKey(name: 'description') String? description,
  }) = _IntegrationEntity;

  factory IntegrationEntity.fromJson(Map<String, dynamic> json) =>
      _$IntegrationEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
