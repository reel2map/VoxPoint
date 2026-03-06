import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_session_mode_dto.freezed.dart';
part 'set_session_mode_dto.g.dart';

@freezed
class SetSessionModeDto with _$SetSessionModeDto {
  const factory SetSessionModeDto({
    @JsonKey(name: 'operator_id') required String operatorId,
    @JsonKey(name: 'session_type') required SessionType sessionType,
  }) = _SetSessionModeDto;

  factory SetSessionModeDto.fromJson(Map<String, dynamic> json) =>
      _$SetSessionModeDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
