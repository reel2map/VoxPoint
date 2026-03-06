import 'package:chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_filter.freezed.dart';
part 'session_filter.g.dart';

@freezed
class SessionFilter with _$SessionFilter {
  const factory SessionFilter({
    @JsonKey(name: 'bot') BotEntity? bot,
    @JsonKey(name: 'user_type') SessionUserType? userType,
    @JsonKey(name: 'length') SessionLength? sessionLength,
    @JsonKey(name: 'user') SessionUserEntity? sessionUserEntity,
    @JsonKey(name: 'user_search') String? userSearch,
    @JsonKey(name: 'logs_count') int? logsCount,
    @JsonKey(name: 'logs_count_op') String? logsCountOp,
    @Default(false) @JsonKey(name: 'use_count') bool useCount,
    @JsonKey(name: 'start_time_from') String? startTimeFrom,
    @JsonKey(name: 'start_time_to') String? startTimeTo,
    @JsonKey(name: 'last_message_time_from') String? lastMessageTimeFrom,
    @JsonKey(name: 'last_message_time_to') String? lastMessageTimeTo,
  }) = _SessionFilter;

  const SessionFilter._();

  factory SessionFilter.fromJson(Map<String, dynamic> json) =>
      _$SessionFilterFromJson(json);

  @override
  Map<String, dynamic> toJson();

  bool get isNotEmpty {
    return bot != null ||
        userType != null ||
        sessionLength != null ||
        sessionUserEntity != null ||
        userSearch != null ||
        logsCount != null ||
        logsCountOp != null ||
        startTimeFrom != null ||
        startTimeTo != null ||
        lastMessageTimeFrom != null ||
        lastMessageTimeTo != null;
  }

  DateTime? get startTimeFromDateTime {
    if (startTimeFrom == null) {
      return null;
    }

    return DateTime.parse(startTimeFrom.toString());
  }

  DateTime? get startTimeToDateTime {
    if (startTimeTo == null) {
      return null;
    }

    return DateTime.parse(startTimeTo.toString());
  }

  DateTime? get lastMessageTimeFromDateTime {
    if (lastMessageTimeFrom == null) {
      return null;
    }

    return DateTime.parse(lastMessageTimeFrom.toString());
  }

  DateTime? get lastMessageTimeToDateTime {
    if (lastMessageTimeTo == null) {
      return null;
    }

    return DateTime.parse(lastMessageTimeTo.toString());
  }
}

enum SessionLength { all, short, medium, long }
