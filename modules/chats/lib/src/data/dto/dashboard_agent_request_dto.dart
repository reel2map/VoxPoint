import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_agent_request_dto.freezed.dart';
part 'dashboard_agent_request_dto.g.dart';

@freezed
class DashboardAgentRequestDto with _$DashboardAgentRequestDto {
  const factory DashboardAgentRequestDto({
    @JsonKey(name: 'period') required PeriodType period,
    @JsonKey(name: 'bot_ids') List<String>? botIds,
  }) = _DashboardAgentRequestDto;

  factory DashboardAgentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardAgentRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
