import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_contact_entity.freezed.dart';
part 'session_contact_entity.g.dart';

@freezed
class SessionContactEntity with _$SessionContactEntity {
  const factory SessionContactEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'external_id') String? externalId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
  }) = _SessionContactEntity;

  factory SessionContactEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionContactEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
