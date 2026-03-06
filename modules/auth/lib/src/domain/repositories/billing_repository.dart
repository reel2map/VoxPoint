import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

abstract class BillingRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions({
    String? tenantId,
  });

  Future<Either<Failure, List<UserEntity>>> getUsers({String? tenantId});
}
