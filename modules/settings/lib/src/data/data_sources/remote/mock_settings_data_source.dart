import 'package:auth/src/domain/models/auth/user/user_entity.dart';
import 'package:settings/src/_src.dart';

class MockSettingsDataSource implements SettingsDataSource {
  @override
  Future<void> removePushToken(String deviceId) {
    // TODO: implement removePushToken
    throw UnimplementedError();
  }

  @override
  Future<void> setPushToken(String deviceId, String? token) {
    // TODO: implement setPushToken
    throw UnimplementedError();
  }

  @override
  Future<void> setMobileSettings(MobilePushConfig config) {
    // TODO: implement setMobileSettings
    throw UnimplementedError();
  }
}
