import 'package:freezed_annotation/freezed_annotation.dart';

part 'url_entity.freezed.dart';
part 'url_entity.g.dart';

@freezed
class UrlEntity with _$UrlEntity {
  const factory UrlEntity({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'value') required String value,
  }) = _UrlEntity;

  factory UrlEntity.fromJson(Map<String, dynamic> json) =>
      _$UrlEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
