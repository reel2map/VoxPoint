import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionMessageModifiedEvent extends Event<LogEntity> {
  SessionMessageModifiedEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionMessageModified);
}
