import 'package:auth/auth.dart';
import 'package:core/core.dart';

class BillingSubscriptionModified extends Event<SubscriptionEntity> {
  BillingSubscriptionModified({required super.data})
    : super(type: ProfileEventType.billingSubscriptionModified);
}
