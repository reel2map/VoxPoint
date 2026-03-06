import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logs_dto.freezed.dart';
part 'logs_dto.g.dart';

@freezed
class LogsDto with _$LogsDto {
  const factory LogsDto({
    @JsonKey(name: 'logs') required List<LogEntity> logs,
    @JsonKey(name: 'next_index') int? nextIndex,
  }) = _LogsDto;

  factory LogsDto.fromJson(Map<String, dynamic> json) =>
      _$LogsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
