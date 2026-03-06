import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_campaign_period_entity.freezed.dart';
part 'dashboard_campaign_period_entity.g.dart';

@freezed
class DashboardCampaignPeriodEntity with _$DashboardCampaignPeriodEntity {
  const factory DashboardCampaignPeriodEntity({
    @JsonKey(name: 'period') required DateTime period,
    @JsonKey(name: 'statuses')
    required List<DashboardCampaignItemEntity> statuses,
    @JsonKey(name: 'stages') required List<DashboardCampaignItemEntity> stages,
  }) = _DashboardCampaignPeriodEntity;

  factory DashboardCampaignPeriodEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardCampaignPeriodEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

@freezed
class DashboardCampaignItemEntity with _$DashboardCampaignItemEntity {
  const factory DashboardCampaignItemEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'value') required int value,
  }) = _DashboardCampaignItemEntity;

  factory DashboardCampaignItemEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardCampaignItemEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
