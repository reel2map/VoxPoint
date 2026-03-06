import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaigns_dto.freezed.dart';
part 'campaigns_dto.g.dart';

@freezed
class CampaignsDto with _$CampaignsDto {
  const factory CampaignsDto({
    @JsonKey(name: 'campaigns') required List<CampaignEntity> campaigns,
    @JsonKey(name: 'next_index') int? nextIndex,
  }) = _CampaignsDto;

  factory CampaignsDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
