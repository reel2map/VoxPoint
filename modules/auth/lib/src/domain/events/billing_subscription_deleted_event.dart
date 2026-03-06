import 'package:auth/auth.dart';
import 'package:core/core.dart';

class BillingSubscriptionDeleted extends Event<SubscriptionEntity> {
  BillingSubscriptionDeleted({required super.data})
    : super(type: ProfileEventType.billingSubscriptionDeleted);
}
