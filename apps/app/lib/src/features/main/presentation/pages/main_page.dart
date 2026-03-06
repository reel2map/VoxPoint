import 'dart:async';

import 'package:app/src/core/_core.dart';
import 'package:app/src/features/main/_main.dart';
import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final botsCubit = sl<BotsCubit>();

  final sessionsCubit = sl<SessionsCubit>();

  final profileCubit = sl<ProfileCubit>();

  final dashboardCubit = sl<DashboardCubit>();

  final webSocketService = sl<WebSocketManager>();

  final supportCubit = sl<SupportChatCubit>();

  final AuthManager<UserEntity> _authManager = sl<AuthManager<UserEntity>>();

  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    webSocketService.connect();

    context.read<SettingsCubit>().initFirebase();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Костыль чтобы получить showBottomMenu из meta информации
      setState(() {});
    });

    _listener = AppLifecycleListener(
      onShow: () async {
        unawaited(_authManager.verify());
        await profileCubit.init();
        await botsCubit.init();
        await sessionsCubit.init();
        await dashboardCubit.init();
        await webSocketService.connect();
      },
      onHide: () async {
        await webSocketService.disconnect();
      },
    );
  }

  Future<void> onPressedPopTop(BuildContext context, int index) async {
    final router = AutoTabsRouter.of(context);

    if (router.activeIndex == index) {
      if (router.canPop()) {
        await router.maybePopTop();

        if (router.canPop()) {
          await onPressedPopTop(context, index);
        }
      }
    }
  }

  bool showBottomMenu(Map<String, dynamic>? data) {
    return data?['showBottomMenu'] == true;
  }

  @override
  void dispose() {
    botsCubit.close();
    sessionsCubit.close();
    profileCubit.close();
    dashboardCubit.close();
    supportCubit.close();

    webSocketService.disconnect();
    _listener.dispose();
    super.dispose();
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              MainI18n.confirmation,
              style: context.texts.subtitle.copyWith(
                color: context.colors.semiBlack,
              ),
            ),
            content: Text(
              MainI18n.confirmationDescription,
              style: context.texts.subtitle.copyWith(
                color: context.colors.semiBlack,
              ),
            ),
            actions: [
              Row(
                spacing: Insets.s,
                children: [
                  Expanded(
                    child: UiButton(
                      type: UiButtonType.secondary,

                      onPressed: () => Navigator.of(context).pop(false),
                      label: CoreI18n.no,
                    ),
                  ),
                  Expanded(
                    child: UiButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      label: CoreI18n.yes,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<MainCubit>()..init()),
        BlocProvider.value(value: botsCubit),
        BlocProvider.value(value: sessionsCubit),
        BlocProvider.value(value: profileCubit),
        BlocProvider.value(value: dashboardCubit),
        BlocProvider.value(value: supportCubit),
      ],
      child: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) {
          return previous.pushNotificationData == null &&
              current.pushNotificationData != null;
        },
        listener: (context, state) {
          context.read<MainCubit>().redirect(state.pushNotificationData ?? {});
        },
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return UiEither(
              condition: state.status.isFetchingSuccess,
              onFalse: const Scaffold(body: UiProgressIndicator()),
              onTrue: AutoTabsRouter(
                lazyLoad: false,
                routes: [
                  const AnalyticsRootRouter(),
                  const SessionsRootRouter(),
                  const AgentsRootRouter(),
                  ChatRootRouter(),
                  const ProfileRootRouter(),
                ],
                builder: (context, child) {
                  final tabsRouter = AutoTabsRouter.of(context);
                  final meta =
                      tabsRouter.current.router.topPage?.routeData.meta;

                  return BlocListener<MainCubit, MainState>(
                    listenWhen: (previous, current) {
                      return previous.redirectPage == null &&
                          current.redirectPage != null;
                    },
                    listener: (context, state) {
                      context.router.navigate(state.redirectPage!);
                    },
                    child: NeoScaffold(
                      // resizeToAvoidBottomInset: false,
                      body: child,
                      bottomNavigationBar: Visibility(
                        visible: showBottomMenu(meta),
                        child: UiBottomNavigationBar(
                          items: [
                            UiNavigationBarItem(
                              selected: tabsRouter.activeIndex == 0,
                              icon: Analytics(
                                color:
                                    tabsRouter.activeIndex == 0
                                        ? context.colors.mainOrange
                                        : context.colors.darkGrey,
                              ),
                              label: ChatsI18n.dashboard.toUpperCase(),
                              onPressed: () {
                                onPressedPopTop(context, 0);

                                tabsRouter.setActiveIndex(0);
                              },
                            ),
                            UiNavigationBarItem(
                              selected: tabsRouter.activeIndex == 1,
                              label: ChatsI18n.sessions.toUpperCase(),
                              icon: UiIcon(
                                Assets.icons.sessionsIcon.path,
                                width: 32,
                                color:
                                    tabsRouter.activeIndex == 1
                                        ? context.colors.mainOrange
                                        : context.colors.darkGrey,
                              ),
                              onPressed: () {
                                onPressedPopTop(context, 1);

                                tabsRouter.setActiveIndex(1);
                              },
                            ),
                            UiNavigationBarItem(
                              selected: tabsRouter.activeIndex == 2,
                              label: ChatsI18n.agents.toUpperCase(),
                              icon: Agents(
                                color:
                                    tabsRouter.activeIndex == 2
                                        ? context.colors.mainOrange
                                        : context.colors.darkGrey,
                              ),
                              onPressed: () {
                                onPressedPopTop(context, 2);

                                tabsRouter.setActiveIndex(2);
                              },
                            ),
                            UiNavigationBarItem(
                              selected: tabsRouter.activeIndex == 3,
                              icon: Chat(
                                color:
                                    tabsRouter.activeIndex == 3
                                        ? context.colors.mainOrange
                                        : context.colors.darkGrey,
                              ),
                              label: AuthI18n.support.toUpperCase(),
                              onPressed: () {
                                onPressedPopTop(context, 3);

                                tabsRouter.setActiveIndex(3);
                              },
                            ),
                            UiNavigationBarItem(
                              selected: tabsRouter.activeIndex == 4,
                              icon: UiIcon(
                                Assets.icons.iconUser.path,
                                color:
                                    tabsRouter.activeIndex == 4
                                        ? context.colors.mainOrange
                                        : context.colors.darkGrey,
                              ),
                              label: AuthI18n.profile.toUpperCase(),
                              onPressed: () {
                                onPressedPopTop(context, 4);

                                tabsRouter.setActiveIndex(4);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
