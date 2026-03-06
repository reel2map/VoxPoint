import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@Injectable(as: BillingRepository)
class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl({required RestBillingDataSource restBillingDataSource})
    : _restBillingDataSource = restBillingDataSource;

  final RestBillingDataSource _restBillingDataSource;

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions({
    String? tenantId,
  }) async {
    try {
      final result = await _restBillingDataSource.getSubscriptions();

      return Right(result.subscriptions);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BillingFailure(code: 0, message: ''));
      }

      return Left(
        BillingFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(BillingFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({String? tenantId}) async {
    try {
      final result = await _restBillingDataSource.getUsers(tenantId: tenantId);

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BillingFailure(code: 0, message: ''));
      }

      return Left(
        BillingFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(BillingFailure(code: 0, message: e.toString()));
    }
  }
}
