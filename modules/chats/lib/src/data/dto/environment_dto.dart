import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment_dto.freezed.dart';
part 'environment_dto.g.dart';

@freezed
class EnvironmentDto with _$EnvironmentDto {
  const factory EnvironmentDto({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'value') String? value,
  }) = _EnvironmentDto;

  factory EnvironmentDto.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
