//@GeneratedMicroModule;AuthPackageModule;package:auth/src/di/auth_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:auth/auth.dart' as _i662;
import 'package:auth/src/_src.dart' as _i1040;
import 'package:auth/src/data/data_sources/remote/mock_auth_data_source.dart'
    as _i628;
import 'package:auth/src/data/data_sources/remote/oauth2_proxy_service.dart'
    as _i570;
import 'package:auth/src/data/data_sources/remote/oauth_service.dart' as _i839;
import 'package:auth/src/data/data_sources/remote/rest_auth_data_source.dart'
    as _i1073;
import 'package:auth/src/data/data_sources/remote/rest_billing_data_source.dart'
    as _i962;
import 'package:auth/src/data/repositories/auth_repository.dart' as _i503;
import 'package:auth/src/data/repositories/billiing_repository.dart' as _i123;
import 'package:auth/src/data/repositories/demo_user_repository.dart' as _i713;
import 'package:auth/src/domain/managers/auth_manager_impl.dart' as _i16;
import 'package:auth/src/domain/use_cases/check_block_use_case.dart' as _i187;
import 'package:auth/src/domain/use_cases/check_local_auth_use_case.dart'
    as _i655;
import 'package:auth/src/domain/use_cases/check_pin_code_use_case.dart'
    as _i118;
import 'package:auth/src/domain/use_cases/get_auth_use_case.dart' as _i91;
import 'package:auth/src/domain/use_cases/login_use_case.dart' as _i1052;
import 'package:auth/src/domain/use_cases/subscribe_auth_event_use_case.dart'
    as _i825;
import 'package:auth/src/domain/use_cases/un_block_use_case.dart' as _i137;
import 'package:auth/src/presentation/states/local_auth_cubit/local_auth_cubit.dart'
    as _i1016;
import 'package:auth/src/presentation/states/login_cubit/login_cubit.dart'
    as _i27;
import 'package:auth/src/presentation/states/profile_cubit/profile_cubit.dart'
    as _i328;
import 'package:auth/src/presentation/states/support_chat_cubit/support_chat_cubit.dart'
    as _i414;
import 'package:chats/chats.dart' as _i221;
import 'package:core/core.dart' as _i494;
import 'package:dependencies/dependencies.dart' as _i340;
import 'package:injectable/injectable.dart' as _i526;
import 'package:settings/settings.dart' as _i133;

class AuthPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i1040.RestAuthDataSource>(
      () => _i628.MockAuthDataSource(),
      instanceName: 'mock',
    );
    gh.factory<_i570.OAuth2ProxyService>(
        () => _i570.OAuth2ProxyServiceImpl(dio: gh<_i340.Dio>()));
    gh.factory<_i1073.RestAuthDataSource>(
        () => _i1073.RestAuthDataSource(gh<_i340.Dio>()));
    gh.factory<_i962.RestBillingDataSource>(
        () => _i962.RestBillingDataSource(gh<_i340.Dio>()));
    gh.factory<_i1040.DemoUserRepository>(() => _i713.DemoUserRepositoryImpl());
    gh.factory<_i494.OAuthService>(() => _i839.OAuthServiceImpl());
    gh.factory<_i1040.AuthRepository<_i1040.AuthModel, _i1040.UserEntity>>(
        () => _i503.AuthRepositoryImpl(
              restAuthDataSource: gh<_i1040.RestAuthDataSource>(),
              oAuthService: gh<_i494.OAuthService>(),
              storage: gh<_i494.AuthStorage>(),
              userSecurityStorage: gh<_i133.UserSecurityStorage>(),
              logger: gh<_i494.Talker>(),
              cookieJar: gh<_i340.CookieJar>(),
            ));
    gh.factory<_i414.SupportChatCubit>(
        () => _i414.SupportChatCubit(botRepository: gh<_i221.BotRepository>()));
    gh.factory<_i662.BillingRepository>(() => _i123.BillingRepositoryImpl(
        restBillingDataSource: gh<_i662.RestBillingDataSource>()));
    gh.lazySingleton<_i1040.AuthManager<_i1040.UserEntity>>(() =>
        _i16.AuthManagerImpl(
          authRepository:
              gh<_i1040.AuthRepository<_i1040.AuthModel, _i1040.UserEntity>>(),
          securityStorage: gh<_i133.UserSecurityStorage>(),
          settingsRepository: gh<_i133.SettingsRepository>(),
          demoUserRepository: gh<_i1040.DemoUserRepository>(),
        ));
    gh.factory<_i91.GetAuthUseCase>(
        () => _i91.GetAuthUseCase(gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i825.SubscribeAuthEventUseCase>(() =>
        _i825.SubscribeAuthEventUseCase(
            gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i1052.LoginUseCase>(
        () => _i1052.LoginUseCase(gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i137.UnBlockUseCase>(() =>
        _i137.UnBlockUseCase(gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i118.CheckPinCodeUseCase>(() =>
        _i118.CheckPinCodeUseCase(gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i187.CheckBlockUseCase>(() =>
        _i187.CheckBlockUseCase(gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i655.CheckLocalAuthUseCase>(() => _i655.CheckLocalAuthUseCase(
        gh<_i1040.AuthManager<_i1040.UserEntity>>()));
    gh.factory<_i27.LoginCubit>(() => _i27.LoginCubit(
          loginUseCase: gh<_i1040.LoginUseCase>(),
          checkBlockUseCase: gh<_i1040.CheckBlockUseCase>(),
          unBlockUseCase: gh<_i1040.UnBlockUseCase>(),
        ));
    gh.factory<_i1016.LocalAuthCubit>(() => _i1016.LocalAuthCubit(
          manager: gh<_i1040.AuthManager<_i1040.UserEntity>>(),
          checkLocalAuthUseCase: gh<_i1040.CheckLocalAuthUseCase>(),
          setPinCodeUseCase: gh<_i133.SetPinCodeUseCase>(),
          checkPinCodeUseCase: gh<_i1040.CheckPinCodeUseCase>(),
          setBiometryUseCase: gh<_i133.SetBiometryUseCase>(),
          checkBiometryUseCase: gh<_i133.CheckBiometryUseCase>(),
          getBiometricSupportModel: gh<_i133.GetBiometricSupportModel>(),
        ));
    gh.factory<_i328.ProfileCubit>(() => _i328.ProfileCubit(
          gh<_i662.AuthManager<_i662.UserEntity>>(),
          gh<_i662.BillingRepository>(),
          gh<_i340.EventBus>(),
        ));
  }
}
