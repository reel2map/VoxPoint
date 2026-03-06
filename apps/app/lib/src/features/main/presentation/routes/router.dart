import 'package:app/src/features/home/_home.dart';
import 'package:app/src/features/main/_main.dart';
import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';

part 'router.gr.dart';

final _chatsRouter = ChatsRouter();

@AutoRouterConfig()
class MainRoutes extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute<void>(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: MainRoute.page,
      path: MainRoutePath.initial,
      guards: [
        AuthGuard(sl<AuthManager<UserEntity>>()),
        BlockAuthGuard(sl<AuthManager<UserEntity>>()),
        LocalAuthGuard(sl<AuthManager<UserEntity>>()),
      ],
      children: [
        ..._chatsRouter.routes,
        CustomRoute<void>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          page: ChatRootRouter.page,
          path: MainRoutePath.chat,
          meta: const {'showBottomMenu': true},
        ),
        CustomRoute<void>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          page: ProfileRootRouter.page,
          path: MainRoutePath.profile,
          meta: const {'showBottomMenu': true},
          children: [
            CustomRoute<void>(
              transitionsBuilder: TransitionsBuilders.fadeIn,
              page: ProfileRoute.page,
              meta: const {'showBottomMenu': true},
              initial: true,
            ),
          ],
        ),
      ],
    ),
    AutoRoute(page: SessionFilterBottomRoute.page)
  ];
}
