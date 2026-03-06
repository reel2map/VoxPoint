import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UiBotWidget extends StatelessWidget {
  const UiBotWidget({
    required this.domain,
    required this.userId,
    required this.userName,
    required this.botId,
    required this.authorizationToken,
    super.key,
    this.sessionId,
  });

  final String domain;
  final String userId;
  final String botId;
  final String userName;
  final String authorizationToken;

  final String? sessionId;

  String get getSessionInitialization =>
      sessionId == null
          ? ''
          : '''
  setTimeout(() => {
         BotChatWidget.openSession("$sessionId");
      }, 10);
     ''';

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: UniqueKey(),
      initialData: InAppWebViewInitialData(
        data: '''
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Chat Widget</title>
      <script src="$domain/public-storage/widget/bot-chat-widget.umd.js"></script>
      <style>
        body {
          margin: 0;
          padding: 0;
          height: 100vh;
          width: 100vw;
          overflow: hidden;
        }
      </style>
    </head>
    <body>
      <div id="chat-widget"></div>
      <script>
        window.addEventListener("load", function() {
          BotChatWidget.createBotChat({
            botRoute: '$domain/chatbot/$botId',
            elementId: 'chat-widget',
            userId: '$userId', 
            userName: '$userName',
            isFloatingBtn: false,
            primaryColor: '#FA8434',
            theme: 'light',
            showActionsBtn: true,
            showWaitingMessage: false,
            authorizationToken: "$authorizationToken",
            voiceOver: false,
            floatingBtnOpennedIconUrl: '',
            floatingBtnClosedIconUrl: '',
            floatingBtnSize: 58,
            version: 'v2',
            multiAgent: true,
            flametreeIconVariant: 'static'
          });
        });

        $getSessionInitialization
      </script>
    </body>
  </html>
  ''',
        baseUrl: WebUri(domain),
      ),
      onReceivedError: (controller, request, error) {
        print('ERROR: $error');
      },

      onPermissionRequest: (controller, permissionRequest) async {
        await requestMicrophonePermission();

        return PermissionResponse(
          resources: permissionRequest.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
    );
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }
}
