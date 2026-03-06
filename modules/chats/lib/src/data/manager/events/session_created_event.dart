import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionCreatedEvent extends Event<SessionEntity> {
  SessionCreatedEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionCreated);
}
