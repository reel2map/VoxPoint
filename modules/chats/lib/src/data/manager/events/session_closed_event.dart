import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionClosedEvent extends Event<SessionEntity> {
  SessionClosedEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionClosed);
}
