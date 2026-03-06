import 'package:auth/src/_src.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_billing_data_source.g.dart';

@Injectable()
@RestApi()
abstract class RestBillingDataSource {
  @factoryMethod
  factory RestBillingDataSource(Dio dio) = _RestBillingDataSource;

  @GET(AuthApiMethods.billing)
  Future<SubscriptionsDto> getSubscriptions({
    @Query('tenant_id') String? tenantId,
  });

  @GET(AuthApiMethods.users)
  Future<List<AuthenticatedUser>> getUsers({
    @Query('tenant_id') String? tenantId,
  });
}
