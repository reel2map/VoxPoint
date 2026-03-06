import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sessions_dto.freezed.dart';
part 'sessions_dto.g.dart';

@freezed
class SessionsDto with _$SessionsDto {
  const factory SessionsDto({
    @JsonKey(name: 'sessions') required List<SessionEntity> sessions,
    @JsonKey(name: 'next_index') int? nextIndex,
  }) = _SessionsDto;

  factory SessionsDto.fromJson(Map<String, dynamic> json) =>
      _$SessionsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
