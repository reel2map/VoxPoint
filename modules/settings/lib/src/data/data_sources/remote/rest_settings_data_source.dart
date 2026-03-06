import 'package:auth/auth.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';
import 'package:settings/src/_src.dart';

part 'rest_settings_data_source.g.dart';

@Injectable(as: SettingsDataSource)
@RestApi()
abstract class RestSettingsDataSource implements SettingsDataSource {
  @factoryMethod
  factory RestSettingsDataSource(Dio dio) = _RestSettingsDataSource;

  @override
  @POST('/api/v1/system/push/mobile_settings/token')
  Future<void> setPushToken(
    @Field('device_id') String deviceId,
    @Field() String? token,
  );

  @override
  @POST('/api/v1/system/push/mobile_settings')
  Future<void> setMobileSettings(@Body() MobilePushConfig config);
  /*
  @override
  @DELETE('/api/v1/system/push/mobile_subscription')
  Future<void> removePushToken(@Field('device_id') String deviceId);*/
}
