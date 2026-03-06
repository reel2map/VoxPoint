import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_users_dto.freezed.dart';
part 'session_users_dto.g.dart';

@freezed
class SessionUsersDto with _$SessionUsersDto {
  const factory SessionUsersDto({
    @JsonKey(name: 'users') required List<SessionUserEntity> users,
    @JsonKey(name: 'next_index') int? nextIndex,
  }) = _SessionUsersDto;

  factory SessionUsersDto.fromJson(Map<String, dynamic> json) =>
      _$SessionUsersDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
