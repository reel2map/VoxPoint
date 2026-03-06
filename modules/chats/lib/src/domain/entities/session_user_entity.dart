import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_user_entity.freezed.dart';
part 'session_user_entity.g.dart';

enum SessionUserType {
  @JsonValue('telegram')
  telegram,
  @JsonValue('whatsapp')
  whatsapp,
  @JsonValue('chatwoot')
  chatwoot,
  @JsonValue('intercom')
  intercom,
  @JsonValue('twilio')
  twilio,
  @JsonValue('web')
  web,
  @JsonValue('email')
  email,
  @JsonValue('sip')
  sip,
  @JsonValue('facebook')
  facebook,
  @JsonValue('birdapiservice')
  birdapiservice,
  @JsonValue('unknown')
  unknown,
}

@freezed
class SessionUserEntity with _$SessionUserEntity {
  const factory SessionUserEntity({
    @JsonKey(name: 'ext_id') required String extId,
    @JsonKey(name: 'type', unknownEnumValue: SessionUserType.unknown)
    required SessionUserType type,
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
  }) = _SessionUserEntity;

  factory SessionUserEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionUserEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
