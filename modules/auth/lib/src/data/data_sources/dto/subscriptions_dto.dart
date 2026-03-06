import 'package:auth/auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriptions_dto.freezed.dart';
part 'subscriptions_dto.g.dart';

@freezed
class SubscriptionsDto with _$SubscriptionsDto {
  const factory SubscriptionsDto({
    @JsonKey(name: 'subscriptions')
    required List<SubscriptionEntity> subscriptions,
    @JsonKey(name: 'enabled') required bool enabled,
    @JsonKey(name: 'error') String? error,
  }) = _SubscriptionsDto;

  factory SubscriptionsDto.fromJson(Object? json) =>
      _$SubscriptionsDtoFromJson(json! as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson();
}
