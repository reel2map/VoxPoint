import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_agent_period_entity.freezed.dart';
part 'dashboard_agent_period_entity.g.dart';

@freezed
class DashboardAgentPeriodEntity with _$DashboardAgentPeriodEntity {
  const factory DashboardAgentPeriodEntity({
    @JsonKey(name: 'period') required DateTime period,
    @Default(0)
    @JsonKey(name: 'operator_sessions_answered_count')
    int operatorSessionsAnsweredCount,
    @Default(0)
    @JsonKey(name: 'human_sessions_answered_count')
    int humanSessionsAnsweredCount,
    @Default(0)
    @JsonKey(name: 'operator_sessions_count')
    int operatorSessionsCount,
    @Default(0)
    @JsonKey(name: 'operator_sessions_resolved_count')
    int operatorSessionsResolvedCount,
    @Default(0)
    @JsonKey(name: 'sessions_avg_messages_count')
    double sessionAvgMessagesCount,
    @Default(0) @JsonKey(name: 'sessions_count') int sessionsCount,
    @Default(0) @JsonKey(name: 'unique_users_count') int uniquesUsersCounts,
  }) = _DashboardAgentPeriodEntity;

  factory DashboardAgentPeriodEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardAgentPeriodEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum PeriodType {
  @JsonValue('WEEK')
  week,
  @JsonValue('MONTH')
  month,
  @JsonValue('YEAR')
  year,
}
