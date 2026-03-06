import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_campaign_request_dto.freezed.dart';
part 'dashboard_campaign_request_dto.g.dart';

@freezed
class DashboardCampaignRequestDto with _$DashboardCampaignRequestDto {
  const factory DashboardCampaignRequestDto({
    @JsonKey(name: 'period') required PeriodType period,
    @JsonKey(name: 'campaign_id') required String campaignId,
  }) = _DashboardCampaignRequestDto;

  factory DashboardCampaignRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardCampaignRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
