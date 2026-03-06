import 'package:auth/auth.dart';
import 'package:core/core.dart';

class BillingSubscriptionCreated extends Event<SubscriptionEntity> {
  BillingSubscriptionCreated({required super.data})
    : super(type: ProfileEventType.billingSubscriptionCreated);
}
