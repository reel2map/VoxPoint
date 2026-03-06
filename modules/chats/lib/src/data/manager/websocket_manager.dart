import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:websocket_universal/websocket_universal.dart';

@LazySingleton(as: WebSocketManager)
class WebsocketManagerImpl implements WebSocketManager {
  WebsocketManagerImpl({
    required AuthManager<UserEntity> authManager,
    required WebsocketMessageHandler webSocketMessageHandler,
    required Talker talker,
  }) : _authManager = authManager,
       _websocketMessageHandler = webSocketMessageHandler,
       _logger = talker;

  final AuthManager<UserEntity> _authManager;

  final WebsocketMessageHandler _websocketMessageHandler;

  final Talker _logger;

  Future<String?> _getToken() async {
    return _authManager.getToken();
  }

  IWebSocketHandler<String, String>? socketHandler;

  @override
  Future<void> connect() async {
    await socketHandler?.disconnect('manual disconnect');

    socketHandler?.close();

    final urlBuilder = UriBuilder.fromUri(Uri.parse(Env.apiUrl));
    urlBuilder
      ..scheme = 'wss'
      ..path = '${urlBuilder.path}/api/v1/ws'
      ..queryParameters = {
        'tenant_id':
            _authManager.user.value.authenticatedOrNull?.tenant?.id ?? '',
      };

    const connectionOptions = SocketConnectionOptions(
      pingIntervalMs: 3000,
      timeoutConnectionMs: 4000,
      pingRestrictionForce: true,
      skipPingMessages: false,
    );

    socketHandler = IWebSocketHandler<String, String>.createClient(
      urlBuilder.toString(),
      SocketSimpleTextProcessor(),
      connectionOptions: connectionOptions,
    );

    /*socketHandler?.logEventStream.listen((debugEvent) {
      // ignore: avoid_print
      print('> debug event: ${debugEvent.socketLogEventType}'
          ' ping=${debugEvent.pingMs} ms. Debug message=${debugEvent.message}');
    });*/

    socketHandler?.socketStateStream.listen((stateEvent) {
      _logger.logCustom(
        TalkerLog('status changed to ${stateEvent.status}', title: 'websocket'),
      );
    });

    socketHandler?.incomingMessagesStream.listen((message) {
      _logger.logCustom(
        TalkerLog('incoming message: $message', title: 'websocket'),
      );
      _websocketMessageHandler.handler(message);
    });

    socketHandler?.outgoingMessagesStream.listen((message) {
      _logger.logCustom(
        TalkerLog('outgoing message: $message', title: 'websocket'),
      );
    });

    final isConnected = await socketHandler?.connect(
      params: SocketOptionalParams(
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      ),
    );

    _logger.logCustom(
      TalkerLog('websocket connected =  $isConnected', title: 'websocket'),
    );
  }

  @override
  Future<void> disconnect() async {
    await socketHandler?.disconnect('manual disconnect');

    socketHandler?.close();
  }
}
