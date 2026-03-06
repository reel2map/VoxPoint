import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionNewMessageEvent extends Event<LogEntity> {
  SessionNewMessageEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionNewMessage);
}
