// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/src/core/di/core_injection_container.dart' as _i531;
import 'package:app/src/core/di/external_injection_container.dart' as _i874;
import 'package:app/src/features/home/_home.dart' as _i318;
import 'package:app/src/features/home/data/data_sources/rest_home_data_source.dart'
    as _i930;
import 'package:app/src/features/home/data/repositories/home_repository.dart'
    as _i748;
import 'package:app/src/features/home/presentation/states/home_cubit/home_cubit.dart'
    as _i469;
import 'package:app/src/features/main/_main.dart' as _i302;
import 'package:app/src/features/main/data/data_sources/rest_main_data_source.dart'
    as _i250;
import 'package:app/src/features/main/data/repositories/main_repository.dart'
    as _i792;
import 'package:app/src/features/main/presentation/states/main_cubit/main_cubit.dart'
    as _i811;
import 'package:auth/auth.dart' as _i662;
import 'package:chats/chats.dart' as _i221;
import 'package:core/core.dart' as _i494;
import 'package:dependencies/dependencies.dart' as _i340;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:settings/settings.dart' as _i133;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    final externalDepsModule = _$ExternalDepsModule();
    gh.factory<_i494.SecureStorage>(() => coreModule.secureStorage);
    await gh.factoryAsync<_i494.SharedStorage>(
      () => coreModule.sharedStorage,
      preResolve: true,
    );
    gh.factory<_i494.AuthStorage>(() => coreModule.authStorage);
    gh.factory<_i221.RestLogDataSource>(() => coreModule.restSessionDataSource);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalDepsModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i340.EventBus>(() => externalDepsModule.eventBus);
    gh.lazySingleton<_i494.AppRouter>(() => coreModule.appRouter);
    gh.lazySingleton<_i494.Talker>(() => coreModule.talker);
    gh.lazySingleton<_i494.DialogService>(() => coreModule.dialogService);
    await gh.lazySingletonAsync<_i340.CookieJar>(
      () => coreModule.cookieJar,
      preResolve: true,
    );
    gh.lazySingleton<_i494.IHttpClient<_i340.Dio>>(
      () => coreModule.iHttpClient,
    );
    gh.lazySingleton<_i340.Dio>(() => coreModule.dio);
    gh.lazySingleton<_i494.AppLogger>(() => coreModule.appLogger);
    gh.factory<_i318.HomeDataSource>(
      () => _i930.RestHomeDataSource(gh<_i340.Dio>()),
    );
    gh.factory<_i302.MainDataSource>(
      () => _i250.RestMainDataSource(gh<_i340.Dio>()),
    );
    gh.factory<_i811.MainCubit>(
      () => _i811.MainCubit(eventBus: gh<_i340.EventBus>()),
    );
    gh.factory<_i302.MainRepository>(
      () => _i792.MainRepositoryImpl(gh<_i302.MainDataSource>()),
    );
    gh.factory<_i318.HomeRepository>(
      () => _i748.HomeRepositoryImpl(gh<_i318.HomeDataSource>()),
    );
    gh.factory<_i469.HomeCubit>(
      () => _i469.HomeCubit(repository: gh<_i318.HomeRepository>()),
    );
    await _i662.AuthPackageModule().init(gh);
    await _i133.SettingsPackageModule().init(gh);
    await _i221.ChatsPackageModule().init(gh);
    return this;
  }
}

class _$CoreModule extends _i531.CoreModule {}

class _$ExternalDepsModule extends _i874.ExternalDepsModule {}
