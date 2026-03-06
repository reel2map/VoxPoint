import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:flutter/material.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class ChatsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute<void>(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: AgentsRootRouter.page,
      path: ChatsRoutePath.agents,
      meta: const {'showBottomMenu': true},
      children: [
        CustomRoute<void>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          page: AgentsRoute.page,
          meta: const {'showBottomMenu': true},
          initial: true,
        ),
        /* AutoRoute(
              page: ChangePinCodeRoute.page,
              path:
                  '${SettingsRoutePath.initial}/${SettingsRoutePath.changePinCode}',
            ),*/
      ],
    ),
    CustomRoute<void>(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: SessionsRootRouter.page,
      path: ChatsRoutePath.sessions,
      meta: const {'showBottomMenu': true},
      children: [
        CustomRoute<void>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          page: SessionsRoute.page,
          meta: const {'showBottomMenu': true},
          initial: true,
        ),
        AutoRoute(
          page: SessionRoute.page,
          path: ChatsRoutePath.session,
          meta: const {'showBottomMenu': false},
        ),
      ],
    ),
    CustomRoute<void>(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: AnalyticsRootRouter.page,
      path: ChatsRoutePath.analytics,
      meta: const {'showBottomMenu': true},
      children: [
        CustomRoute<void>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          page: AnalyticsRoute.page,
          meta: const {'showBottomMenu': true},
          initial: true,
        ),
      ],
    ),
    AutoRoute(
      page: SessionFilterBottomRoute.page,
      meta: const {'showBottomMenu': false},
    ),
  ];
}
