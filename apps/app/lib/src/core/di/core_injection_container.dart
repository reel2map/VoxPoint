import 'package:app/src/features/main/_main.dart';
import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:settings/settings.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

@module
abstract class CoreModule {
  @lazySingleton
  AppRouter get appRouter => AppRouter(
    navigatorKey: DialogService.navigatorKey,
    routes: [
      ...AuthRoutes().routes,
      ...MainRoutes().routes,
      AutoRoute(
        page: ChangePinCodeRoute.page,
        path:
            '/${SettingsRoutePath.initial}/${SettingsRoutePath.changePinCode}',
      ),
      RedirectRoute(path: '*', redirectTo: '/'),
    ],
  );

  @injectable
  SecureStorage get secureStorage => SecureStorage(key: Env.secureKey);

  @preResolve
  Future<SharedStorage> get sharedStorage => SharedStorage.init();

  @lazySingleton
  Talker get talker => TalkerFlutter.init(settings: TalkerSettings());

  @lazySingleton
  DialogService get dialogService => DialogService();

  @injectable
  AuthStorage get authStorage => AuthStorage(storage: sl());

  @preResolve
  @lazySingleton
  Future<CookieJar> get cookieJar async => PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage((await getTemporaryDirectory()).path),
  );

  @lazySingleton
  IHttpClient<Dio> get iHttpClient {
    final client = DioHttpClient(url: Uri.parse(Env.apiUrl), cookieJar: sl());

    client.client.interceptors.addAll([
      AuthInterceptor(sl(), sl()),
      TalkerDioLogger(
        talker: sl(),
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseData: false,
        ),
      ),
    ]);

    return client;
  }

  @lazySingleton
  Dio get dio => GetIt.I<IHttpClient<Dio>>().client;

  @injectable
  RestLogDataSource get restSessionDataSource {
    return RestLogDataSource(sl<Dio>().clone(interceptors: Interceptors()));
  }

  @lazySingleton
  AppLogger get appLogger => AppLogger();
}
