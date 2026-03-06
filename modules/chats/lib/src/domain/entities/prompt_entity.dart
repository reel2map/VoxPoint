import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_entity.freezed.dart';
part 'prompt_entity.g.dart';

@freezed
class PromptEntity with _$PromptEntity {
  const factory PromptEntity({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'name') String? name,
  }) = _PromptEntity;

  factory PromptEntity.fromJson(Map<String, dynamic> json) =>
      _$PromptEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
