import 'package:auth/auth.dart';

abstract class SettingsDataSource {
  Future<void> setPushToken(String deviceId, String? token);

  Future<void> setMobileSettings(MobilePushConfig config);

  //  Future<void> removePushToken(String deviceId);
}
