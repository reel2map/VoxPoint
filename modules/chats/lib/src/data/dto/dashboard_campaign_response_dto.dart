import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_campaign_response_dto.freezed.dart';
part 'dashboard_campaign_response_dto.g.dart';

@freezed
class DashboardCampaignResponseDto with _$DashboardCampaignResponseDto {
  const factory DashboardCampaignResponseDto({
    @JsonKey(name: 'data') required List<DashboardCampaignPeriodEntity> data,
  }) = _DashboardCampaignResponseDto;

  factory DashboardCampaignResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardCampaignResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
