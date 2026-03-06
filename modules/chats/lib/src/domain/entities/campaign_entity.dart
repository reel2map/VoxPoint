import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_entity.freezed.dart';
part 'campaign_entity.g.dart';

@freezed
class CampaignEntity with _$CampaignEntity {
  const factory CampaignEntity({
    @JsonKey(name: 'created_on') required DateTime createdOn,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'modified_on') required DateTime modifiedOn,
    @JsonKey(name: 'modified_by') required String modifiedBy,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'status') required CampaignStatusEntity status,
    @Default([])
    @JsonKey(name: 'strategies')
    List<CampaignStrategyEntity> strategies,
    @Default([])
    @JsonKey(name: 'contacts')
    List<CampaignContactEntity> contacts,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'results') List<CampaignResultEntity>? results,
  }) = _CampaignEntity;

  factory CampaignEntity.fromJson(Map<String, dynamic> json) =>
      _$CampaignEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class CampaignStatusEntity with _$CampaignStatusEntity {
  const factory CampaignStatusEntity({
    @JsonKey(name: 'status', unknownEnumValue: CampaignStatus.unknown)
    required CampaignStatus status,
    @JsonKey(name: 'message') String? message,
  }) = _CampaignStatusEntity;

  factory CampaignStatusEntity.fromJson(Map<String, dynamic> json) =>
      _$CampaignStatusEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class CampaignContactEntity with _$CampaignContactEntity {
  const factory CampaignContactEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'external_id') String? externalId,
    @JsonKey(name: 'object_id') String? objectId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
  }) = _CampaignContactEntity;

  factory CampaignContactEntity.fromJson(Map<String, dynamic> json) =>
      _$CampaignContactEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class CampaignStrategyEntity with _$CampaignStrategyEntity {
  const factory CampaignStrategyEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'type', unknownEnumValue: CampaignStrategyType.unknown)
    required CampaignStrategyType type,
  }) = _CampaignStrategyEntity;

  factory CampaignStrategyEntity.fromJson(Map<String, dynamic> json) =>
      _$CampaignStrategyEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class CampaignResultEntity with _$CampaignResultEntity {
  const factory CampaignResultEntity({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
  }) = _CampaignResultEntity;

  factory CampaignResultEntity.fromJson(Map<String, dynamic> json) =>
      _$CampaignResultEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum CampaignStatus {
  @JsonValue('CREATED')
  created,
  @JsonValue('CONFIGURED')
  configured,
  @JsonValue('RUNNING')
  running,
  @JsonValue('ERROR')
  error,
  @JsonValue('UNKNOWN')
  unknown,
}

enum CampaignStrategyType {
  @JsonValue('DATA_LOAD')
  dataLoad,
  @JsonValue('AGGREGATION')
  aggregation,
  @JsonValue('INTERMEDIATE_ANALYSIS')
  intermediateAnalysis,
  @JsonValue('UNKNOWN')
  unknown,
}
