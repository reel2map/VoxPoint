import 'package:app/l10n/app_localization_delegate.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/_core.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:settings/settings.dart';
import 'package:ui_kit/ui_kit.dart';

class App extends StatefulWidget {
  const App({required this.routerConfig, super.key});

  final RouterConfig<Object> routerConfig;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: sl()..init(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen:
            (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.locale != current.locale ||
                previous.status != current.status,
        builder: (context, state) {
          return MaterialApp.router(
            scaffoldMessengerKey: NotifyService.scaffoldMessengerKey,
            routerConfig: widget.routerConfig,
            themeMode: ThemeMode.light, //  state.themeMode,
            theme: createLightTheme(),
            darkTheme: createDarkTheme(),
            debugShowCheckedModeBanner: false,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onNavigationNotification: (_) {
              switch (WidgetsBinding.instance.lifecycleState) {
                case null:
                case AppLifecycleState.detached:
                case AppLifecycleState.inactive:
                  // Avoid updating the engine when the app isn't ready.
                  return true;
                case AppLifecycleState.resumed:
                case AppLifecycleState.hidden:
                case AppLifecycleState.paused:
                  // This must be `true` instead of `notification.canHandlePop`, otherwise application closes on back gesture.
                  SystemNavigator.setFrameworkHandlesBack(true);
                  return true;
              }
            },
            builder: (context, child) {
              return FutureBuilder(
                future: AppInitializer.completer.future,
                builder: (context, snapshot) {
                  if (!state.status.isFetchingSuccess ||
                      snapshot.connectionState != ConnectionState.done) {
                    return const SplashPage();
                  }

                  if (state.requireUpdate) {
                    return const UpdatePage();
                  }

                  return child ?? const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}
