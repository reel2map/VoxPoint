import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_entity.freezed.dart';
part 'channel_entity.g.dart';

@freezed
class ChannelEntity with _$ChannelEntity {
  const factory ChannelEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'inbound') required bool inbound,
  }) = _ChannelEntity;

  factory ChannelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
