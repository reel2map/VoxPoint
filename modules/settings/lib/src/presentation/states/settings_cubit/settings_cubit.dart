import 'dart:async';
import 'dart:io';

import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends BaseCubit<SettingsState> {
  SettingsCubit({
    required this.getBiometryUseCase,
    required this.appInfo,
    required this.deviceInfo,
    required this.getBiometricSupportModel,
    required this.setBiometrySettingUseCase,
    required this.setLocalAuthUseCase,
    required this.getLocalAuthUseCase,
    required Talker logger,
    required SettingsRepository repository,
    required AuthManager<UserEntity> authManager,

    AuthSettings? authSettings,
  }) : _repository = repository,
       _authManager = authManager,
       _authSettings =
           authSettings ??
           const AuthSettings(useBiometric: true, useLocalAuth: true),
       _logger = logger,
       super(
         SettingsState(
           appInfo: appInfo,
           deviceInfo: deviceInfo,
           authSettings:
               authSettings ??
               const AuthSettings(useBiometric: true, useLocalAuth: true),
         ),
       );

  final AuthManager<UserEntity> _authManager;

  final AuthSettings _authSettings;

  final SettingsRepository _repository;

  final AppInfoModel appInfo;

  final DeviceInfoModel deviceInfo;

  final GetBiometricSupportModel getBiometricSupportModel;

  final SetBiometrySettingUseCase setBiometrySettingUseCase;

  final SetLocalAuthUseCase setLocalAuthUseCase;

  final GetLocalAuthUseCase getLocalAuthUseCase;

  final GetBiometryUseCase getBiometryUseCase;

  final List<StreamSubscription<dynamic>> _streams = [];

  final Talker _logger;

  Future<void> init() async {
    _streams.add(
      _authManager.user.listen((value) {
        emit(state.copyWith(user: value.authenticatedOrNull));
      }),
    );

    await getSettings();
    await getVersions();

    emit(state.copyWith(status: FetchStatus.fetchingSuccess));

    await initLocalAuth();
  }

  Future<void> initLocalAuth() async {
    final biometricSupportModel = await _getBiometricSupportModel();

    bool useLocalAuth = _authSettings.canUseLocalAuth;
    bool? useBiometric;

    if (useLocalAuth) {
      useLocalAuth =
          await getLocalAuthUseCase() ?? _authSettings.canUseLocalAuth;

      useBiometric =
          biometricSupportModel.status == BiometricStatus.notAvailable
              ? null
              : await getBiometryUseCase();
    }

    emit(
      state.copyWith(
        useBiometric: useBiometric,
        useLocalAuth: useLocalAuth,
        status: FetchStatus.fetchingSuccess,
      ),
    );
  }

  Future<BiometricSupportModel> _getBiometricSupportModel() async {
    if (!_authSettings.useBiometric) {
      return const BiometricSupportModel(useBiometric: false);
    }

    return getBiometricSupportModel();
  }

  Future<void> setBiometry({required bool value}) async {
    await setBiometrySettingUseCase(value);

    emit(state.copyWith(useBiometric: value));
  }

  Future<void> setUseLocalAuth({required bool value}) async {
    emit(state.copyWith(useLocalAuth: value));

    await setLocalAuthUseCase(value);
  }

  Future<void> getSettings() async {
    final result = await _repository.getUserSettings();

    result.fold(
      (l) {
        emit(state.copyWith(status: FetchStatus.fetchingFailure));
      },
      (response) {
        emit(
          state.copyWith(
            locale: response.locale,
            themeMode: response.themeMode,
            checkPushNotifications: response.checkPushNotifications,
          ),
        );
      },
    );
  }

  Future<void> getVersions() async {
    final result = await _repository.getStoreVersion();

    result.fold((error) {}, (response) {
      emit(state.copyWith(storeVersion: response));
    });
  }

  Future<void> signOut() async {
    final result = await DialogService.showDialog<bool>(
      child: UiConfirmDialog(title: SettingsI18n.signOutTitle),
    );

    if (result ?? false) {
      await sl<AuthManager<UserEntity>>().signOut();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    emit(state.copyWith(locale: locale));

    await _repository.setLocale(locale);
  }

  Future<void> setThemeMode(ThemeMode? themeMode) async {
    emit(state.copyWith(themeMode: themeMode));

    await _repository.setThemeMode(themeMode);
  }

  Future<void> initFirebase() async {
    final bool isAvailable = await _isGmsAvailable();

    emit(state.copyWith(isPushAvailable: isAvailable));

    if (!isAvailable) {
      return;
    }

    await enablePushToken();

    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      emit(state.copyWith(pushNotificationData: message.data));
      _logger.logCustom(
        TalkerLog(
          'initial push  = title: ${message.notification?.title}, description = ${message.notification?.body} , data= ${message.data}',
          title: 'push',
        ),
      );
    }

    _streams
      ..add(
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          /*    _logger.logCustom(
            TalkerLog(
              'on push = title: ${message.notification?.title}, description = ${message.notification?.body} , data= ${message.data}',
              title: 'push',
            ),
          );*/
        }),
      )
      ..add(
        FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage message,
        ) async {
          emit(state.copyWith(pushNotificationData: message.data));

          _logger.logCustom(
            TalkerLog(
              'on push opened app  = title: ${message.notification?.title}, description = ${message.notification?.body} , data= ${message.data}',
              title: 'push',
            ),
          );

          await Future<void>.delayed(const Duration(milliseconds: 600));

          emit(state.copyWith(pushNotificationData: null));
        }),
      )
      ..add(
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
          _repository.setPushToken(
            deviceId: state.deviceInfo.deviceId,
            token: token,
          );
        }),
      );
  }

  Future<void> enablePushToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Запрашиваем разрешение
    await messaging.requestPermission();

    // Получение токена
    final String? token = await messaging.getToken();

    if (token != null) {
      await _repository.setPushToken(
        deviceId: state.deviceInfo.deviceId,
        token: token,
      );

      await _authManager.verify();
    }

    emit(state.copyWith(usePushNotification: token != null));
  }

  Future<void> enableSystemPushNotifications() async {
    if (state.user != null) {
      await _repository.setPushSettings(
        state.user!.mobilePushConfig.copyWith(systemEnabled: true),
      );

      await _authManager.verify();
    }
  }

  Future<void> disableSystemPushNotifications() async {
    if (state.user != null) {
      await _repository.setPushSettings(
        state.user!.mobilePushConfig.copyWith(systemEnabled: false),
      );

      await _authManager.verify();
    }
  }

  Future<void> enableClientPushNotifications() async {
    if (state.user != null) {
      await _repository.setPushSettings(
        state.user!.mobilePushConfig.copyWith(agentsEnabled: true),
      );

      await _authManager.verify();
    }
  }

  Future<void> disableClientPushNotifications() async {
    if (state.user != null) {
      await _repository.setPushSettings(
        state.user!.mobilePushConfig.copyWith(agentsEnabled: false),
      );

      await _authManager.verify();
    }
  }

  Future<bool> _isGmsAvailable() async {
    if (Platform.isIOS) {
      return true;
    }

    const platform = MethodChannel('ai.flametree/gms_check');

    try {
      return await platform.invokeMethod<bool>('isGmsAvailable') ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> close() async {
    for (final element in _streams) {
      await element.cancel();
    }

    await super.close();
  }
}
