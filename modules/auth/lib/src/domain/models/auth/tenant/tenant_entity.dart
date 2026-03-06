import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_entity.freezed.dart';
part 'tenant_entity.g.dart';

@freezed
class TenantEntity with _$TenantEntity {
  const factory TenantEntity({
    @JsonKey(name: 'created_on') required DateTime createdOn,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'modified_on') required DateTime modifiedOn,
    @JsonKey(name: 'modified_by') required String modifiedBy,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'access_to_public') required bool accessToPublic,
    @JsonKey(name: 'api_key') required String apiKey,
    @JsonKey(name: 'sessions_count') required int sessionsCount,
    @JsonKey(name: 'sessions_limit') required int sessionsLimit,
    @Default(false) @JsonKey(name: 'readonly') bool readOnly,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'website') String? website,
    @JsonKey(name: 'street') String? street,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'zip_code') String? zipCode,
    @JsonKey(name: 'country') String? country,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'billing_email') String? billingEmail,
  }) = _TenantEntity;

  factory TenantEntity.fromJson(Object? json) =>
      _$TenantEntityFromJson(json! as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson();
}
