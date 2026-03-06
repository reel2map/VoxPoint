import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_entity.freezed.dart';
part 'subscription_entity.g.dart';

@freezed
class SubscriptionEntity with _$SubscriptionEntity {
  const factory SubscriptionEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'type', unknownEnumValue: SubscriptionType.unknown)
    required SubscriptionType type,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'next_invoice_date') required DateTime nextInvoiceDate,
    @JsonKey(name: 'extra_available') required bool extraAvailable,
    @JsonKey(name: 'sessions_limit') required int sessionsLimit,
    @JsonKey(name: 'sessions_count') required int sessionsCount,
  }) = _SubscriptionEntity;

  factory SubscriptionEntity.fromJson(Object? json) =>
      _$SubscriptionEntityFromJson(json! as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson();
}

enum SubscriptionType {
  @JsonValue('sme_extra')
  smeExtra,
  @JsonValue('free')
  free,
  @JsonValue('sme_base')
  smeBase,
  @JsonValue('enterprise')
  enterprise,
  @JsonValue('unknown')
  unknown,
}
