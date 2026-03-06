import 'package:auth/src/_src.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_auth_data_source.g.dart';

@Injectable()
@RestApi()
abstract class RestAuthDataSource {
  @factoryMethod
  factory RestAuthDataSource(Dio dio) = _RestAuthDataSource;

  @GET(AuthApiMethods.verify)
  Future<AuthenticatedUser> verify({@Query('device_id') String? deviceId});
}
