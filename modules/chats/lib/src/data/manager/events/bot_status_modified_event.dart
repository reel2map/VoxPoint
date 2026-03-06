import 'package:chats/chats.dart';
import 'package:core/core.dart';

class BotStatusModifiedEvent extends Event<BotEntity> {
  BotStatusModifiedEvent({required super.data})
    : super(type: WebsocketMessageTypes.botStatusModified);
}
