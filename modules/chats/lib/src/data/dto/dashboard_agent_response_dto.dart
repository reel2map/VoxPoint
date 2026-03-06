import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_agent_response_dto.freezed.dart';
part 'dashboard_agent_response_dto.g.dart';

@freezed
class DashboardAgentResponseDto with _$DashboardAgentResponseDto {
  const factory DashboardAgentResponseDto({
    @JsonKey(name: 'data') required List<DashboardAgentPeriodEntity> data,
  }) = _DashboardAgentResponseDto;

  factory DashboardAgentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardAgentResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
