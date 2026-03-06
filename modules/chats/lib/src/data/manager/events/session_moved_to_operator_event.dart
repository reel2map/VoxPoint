import 'package:chats/chats.dart';
import 'package:core/core.dart';

class SessionMovedToOperatorEvent extends Event<SessionEntity> {
  SessionMovedToOperatorEvent({required super.data})
    : super(type: WebsocketMessageTypes.sessionMovedToOperator);
}
