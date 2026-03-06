//@GeneratedMicroModule;SettingsPackageModule;package:settings/src/di/settings_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:dependencies/dependencies.dart' as _i340;
import 'package:injectable/injectable.dart' as _i526;
import 'package:settings/settings.dart' as _i133;
import 'package:settings/src/_src.dart' as _i25;
import 'package:settings/src/data/data_sources/cache/user_security_storage.dart'
    as _i1001;
import 'package:settings/src/data/data_sources/remote/rest_settings_data_source.dart'
    as _i634;
import 'package:settings/src/data/repositories/biometric_repository.dart'
    as _i924;
import 'package:settings/src/data/repositories/settings_repository.dart'
    as _i819;
import 'package:settings/src/di/settings_di.dart' as _i643;
import 'package:settings/src/domain/use_cases/check_biometry_use_case.dart'
    as _i108;
import 'package:settings/src/domain/use_cases/check_pin_code_from_dialog_use_case.dart'
    as _i940;
import 'package:settings/src/domain/use_cases/get_biometric_support_model_use_case.dart'
    as _i842;
import 'package:settings/src/domain/use_cases/get_biometry_use_case.dart'
    as _i801;
import 'package:settings/src/domain/use_cases/get_local_auth_use_case.dart'
    as _i1022;
import 'package:settings/src/domain/use_cases/set_biometry_setting_use_case.dart'
    as _i399;
import 'package:settings/src/domain/use_cases/set_biometry_use_case.dart'
    as _i66;
import 'package:settings/src/domain/use_cases/set_local_auth_use_case.dart'
    as _i803;
import 'package:settings/src/domain/use_cases/set_pin_code_use_case.dart'
    as _i66;
import 'package:settings/src/presentation/states/change_pin_code/change_pin_code_cubit.dart'
    as _i94;

class SettingsPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final settingsDiModule = _$SettingsDiModule();
    gh.factory<_i25.SettingsDataSource>(
        () => _i634.RestSettingsDataSource(gh<_i340.Dio>()));
    gh.factory<_i1001.UserSecurityStorage>(
        () => _i1001.UserSecurityStorage(storage: gh<_i494.SecureStorage>()));
    gh.factory<_i25.BiometricRepository>(() => _i924.BiometricRepositoryImpl(
        userSecurityStorage: gh<_i25.UserSecurityStorage>()));
    gh.factory<_i940.CheckPinCodeFromDialogUseCase>(() =>
        _i940.CheckPinCodeFromDialogUseCase(gh<_i25.UserSecurityStorage>()));
    gh.factory<_i66.SetPinCodeUseCase>(
        () => _i66.SetPinCodeUseCase(gh<_i25.UserSecurityStorage>()));
    gh.factory<_i25.SettingsRepository>(() => _i819.SettingsRepositoryImpl(
          dataSource: gh<_i25.SettingsDataSource>(),
          sharedStorage: gh<_i494.SharedStorage>(),
        ));
    gh.factory<_i399.SetBiometrySettingUseCase>(
        () => _i399.SetBiometrySettingUseCase(gh<_i25.BiometricRepository>()));
    gh.factory<_i842.GetBiometricSupportModel>(
        () => _i842.GetBiometricSupportModel(gh<_i25.BiometricRepository>()));
    gh.factory<_i801.GetBiometryUseCase>(
        () => _i801.GetBiometryUseCase(gh<_i25.BiometricRepository>()));
    gh.factory<_i66.SetBiometryUseCase>(
        () => _i66.SetBiometryUseCase(gh<_i25.BiometricRepository>()));
    gh.factory<_i108.CheckBiometryUseCase>(
        () => _i108.CheckBiometryUseCase(gh<_i25.BiometricRepository>()));
    gh.factory<_i803.SetLocalAuthUseCase>(
        () => _i803.SetLocalAuthUseCase(gh<_i133.UserSecurityStorage>()));
    gh.factory<_i1022.GetLocalAuthUseCase>(
        () => _i1022.GetLocalAuthUseCase(gh<_i133.UserSecurityStorage>()));
    await gh.lazySingletonAsync<_i25.SettingsCubit>(
      () => settingsDiModule.settingsCubit(
        gh<_i25.GetBiometricSupportModel>(),
        gh<_i25.SetBiometrySettingUseCase>(),
        gh<_i25.SetLocalAuthUseCase>(),
        gh<_i25.GetLocalAuthUseCase>(),
        gh<_i25.SettingsRepository>(),
        gh<_i25.GetBiometryUseCase>(),
      ),
      preResolve: true,
    );
    gh.factory<_i94.ChangePinCodeCubit>(() => _i94.ChangePinCodeCubit(
          gh<_i25.CheckPinCodeFromDialogUseCase>(),
          gh<_i25.SetPinCodeUseCase>(),
        ));
  }
}

class _$SettingsDiModule extends _i643.SettingsDiModule {}
