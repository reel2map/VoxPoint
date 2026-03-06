import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_filter.freezed.dart';
part 'bot_filter.g.dart';

@freezed
class BotFilter with _$BotFilter {
  const factory BotFilter({
    @JsonKey(name: 'text') String? text,
    @Default(SortType.asc) @JsonKey(name: 'sort') SortType sort,
    @Default([]) List<BotStatus> statuses,
  }) = _BotFilter;

  factory BotFilter.fromJson(Map<String, dynamic> json) =>
      _$BotFilterFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum SortType { asc, desc }
