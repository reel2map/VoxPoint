import 'package:core/core.dart';

class BillingFailure extends Failure {
  BillingFailure({required super.code, required super.message});

  @override
  String getLocalizedString() {
    switch (code) {
      default:
        return 'unknownError';
    }
  }
}
