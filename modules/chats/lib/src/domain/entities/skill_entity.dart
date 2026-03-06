import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_entity.freezed.dart';
part 'skill_entity.g.dart';

@freezed
class SkillEntity with _$SkillEntity {
  const factory SkillEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _SkillEntity;

  factory SkillEntity.fromJson(Map<String, dynamic> json) =>
      _$SkillEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
