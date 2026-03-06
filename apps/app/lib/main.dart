import 'dart:async';

import 'package:app/firebase_options_dev.dart' as dev;
import 'package:app/firebase_options_prod.dart' as prod;
import 'package:app/firebase_options_test.dart' as test;
import 'package:app/src/core/_core.dart';
import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

FutureOr<void> main() async {
  configureUrlStrategyApp();

  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print('🔔 Background message: ${message.messageId}');
  }

  await runZonedGuarded(
    () async {
      AppInitializer.initDependencies = () async {
        try {
          await configureDependencies(Flavor.status);
        } catch (error, stacktrace) {
          if (kDebugMode) {
            print('Error: $error, $stacktrace');
          }
        }
      };

      AppInitializer.initFirebase = () async {
        if (Flavor.status == FlavorStatus.development) {
          await Firebase.initializeApp(
            options: dev.DefaultFirebaseOptions.currentPlatform,
          );
        } else if (Flavor.status == FlavorStatus.production) {
          await Firebase.initializeApp(
            options: prod.DefaultFirebaseOptions.currentPlatform,
          );
        } else if (Flavor.status == FlavorStatus.testing) {
          await Firebase.initializeApp(
            options: test.DefaultFirebaseOptions.currentPlatform,
          );
        }

        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
      };

      await AppInitializer(status: Flavor.status).init(() {
        final AppRouter _router = sl<AppRouter>();

        return StreamBuilder<Key>(
          stream: AppInitializer.key.stream,
          builder: (context, snapshot) {
            return App(
              key: snapshot.data,
              routerConfig: _router.config(
                reevaluateListenable: sl<AuthManager<UserEntity>>(),
                includePrefixMatches: true,
                navigatorObservers: () => [AppRouteObserver(sl<AppLogger>())],
                deepLinkBuilder: (PlatformDeepLink deepLink) async {
                  // return const DeepLink.path('/profile?tab=2');
                  if (_router.redirectUrl != null) {
                    final _url = _router.redirectUrl;

                    _router.redirectUrl = null;

                    return DeepLink.path(_url!);
                  }

                  if (deepLink.path == '/') {
                    return DeepLink.path(_router.initialRoute);
                  }

                  return deepLink;
                },
              ),
            );
          },
        );
      });
    },
    (error, stackTrace) {
      TerminalLogger.log(
        error.toString(),
        name: 'onFlutterError',
        stackTrace: stackTrace,
        error: error,
      );
    },
  );
}
