import 'package:dependencies/dependencies.dart' as dep;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@Deprecated('use oAuthService')
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late InAppWebViewController _webViewController;
  final String authUrl =
      'https://portal.flametree.dev.enfint.ai/auth/oauth2/start?rd=https://portal.flametree.dev.enfint.ai/';

  final dep.CookieJar cookieJar = dep.sl();

  bool complete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(authUrl)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        gestureRecognizers: const {
          Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
        },
        initialSettings: InAppWebViewSettings(
          supportZoom: false, // Отключить масштабирование, если оно мешает
          supportMultipleWindows: true,
        ),
        onLoadStart: (controller, url) {
          // Обработка начала загрузки страницы
          print('Loading: $url');
        },
        onLoadStop: (controller, url) async {
          // Обработка завершения загрузки страницы
          print('Loaded: $url');

          // Проверка URL для обработки callback
          if (url.toString() == 'https://portal.flametree.dev.enfint.ai/') {
            // Закрыть WebView и вернуться в приложение
            final cookies = await CookieManager.instance().getCookies(
              url: WebUri('https://portal.flametree.dev.enfint.ai'),
            );
            await cookieJar.deleteAll();

            await cookieJar.saveFromResponse(
              Uri.parse('https://portal.flametree.dev.enfint.ai'),
              cookies
                  .map((e) => dep.Cookie(e.name, e.value.toString()))
                  .toList(),
            );

            if (!complete) {
              complete = true;
              Navigator.of(context).pop(true);
            }
          }
        },
      ),
    );
  }
}
