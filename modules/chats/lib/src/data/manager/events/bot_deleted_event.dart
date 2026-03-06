import 'package:chats/chats.dart';
import 'package:core/core.dart';

class BotDeletedEvent extends Event<BotEntity> {
  BotDeletedEvent({required super.data})
    : super(type: WebsocketMessageTypes.botDeleted);
}
