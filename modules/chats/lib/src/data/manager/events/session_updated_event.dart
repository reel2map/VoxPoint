import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionUpdatedEvent extends Event<SessionEntity> {
  SessionUpdatedEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionUpdated);
}
