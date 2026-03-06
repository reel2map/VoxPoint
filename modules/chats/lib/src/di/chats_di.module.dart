//@GeneratedMicroModule;ChatsPackageModule;package:chats/src/di/chats_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:auth/auth.dart' as _i662;
import 'package:chats/chats.dart' as _i221;
import 'package:chats/src/data/data_sources/remote/rest_bot_data_source.dart'
    as _i946;
import 'package:chats/src/data/data_sources/remote/rest_sessions_data_source.dart'
    as _i666;
import 'package:chats/src/data/manager/websocket_manager.dart' as _i565;
import 'package:chats/src/data/manager/websocket_message_handler.dart' as _i764;
import 'package:chats/src/data/repositories/bot_repository.dart' as _i65;
import 'package:chats/src/data/repositories/sessions_repository.dart' as _i654;
import 'package:chats/src/presentation/states/bots/bots_cubit.dart' as _i574;
import 'package:chats/src/presentation/states/dashboard/dashboard_cubit.dart'
    as _i705;
import 'package:chats/src/presentation/states/session/session_cubit.dart'
    as _i1017;
import 'package:chats/src/presentation/states/sessions/sessions_cubit.dart'
    as _i462;
import 'package:core/core.dart' as _i494;
import 'package:dependencies/dependencies.dart' as _i340;
import 'package:injectable/injectable.dart' as _i526;
import 'package:settings/settings.dart' as _i133;

class ChatsPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i946.RestBotDataSource>(
        () => _i946.RestBotDataSource(gh<_i340.Dio>()));
    gh.factory<_i666.RestSessionsDataSource>(
        () => _i666.RestSessionsDataSource(gh<_i340.Dio>()));
    gh.factory<_i221.SessionsRepository>(() => _i654.SessionsRepositoryImpl(
          restSessionsDataSource: gh<_i221.RestSessionsDataSource>(),
          restLogDataSource: gh<_i221.RestLogDataSource>(),
        ));
    gh.factory<_i764.WebsocketMessageHandler>(
        () => _i764.WebsocketMessageHandler(
              eventBus: gh<_i340.EventBus>(),
              logger: gh<_i494.Talker>(),
            ));
    gh.factory<_i462.SessionsCubit>(() => _i462.SessionsCubit(
          gh<_i221.SessionsRepository>(),
          gh<_i662.AuthManager<_i662.UserEntity>>(),
          gh<_i340.EventBus>(),
        ));
    gh.factory<_i1017.SessionCubit>(() => _i1017.SessionCubit(
          gh<_i221.SessionsRepository>(),
          gh<_i662.AuthManager<_i662.UserEntity>>(),
          gh<_i340.EventBus>(),
        ));
    gh.factory<_i705.DashboardCubit>(() => _i705.DashboardCubit(
          gh<_i221.SessionsRepository>(),
          gh<_i662.AuthManager<_i662.UserEntity>>(),
        ));
    gh.factory<_i221.BotRepository>(() => _i65.BotRepositoryImpl(
        restBotDataSource: gh<_i221.RestBotDataSource>()));
    gh.lazySingleton<_i221.WebSocketManager>(() => _i565.WebsocketManagerImpl(
          authManager: gh<_i662.AuthManager<_i662.UserEntity>>(),
          webSocketMessageHandler: gh<_i221.WebsocketMessageHandler>(),
          talker: gh<_i494.Talker>(),
        ));
    gh.factory<_i574.BotsCubit>(() => _i574.BotsCubit(
          gh<_i221.BotRepository>(),
          gh<_i662.AuthManager<_i662.UserEntity>>(),
          gh<_i340.EventBus>(),
          gh<_i133.SettingsRepository>(),
        ));
  }
}
