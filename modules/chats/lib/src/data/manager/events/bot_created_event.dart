import 'package:chats/chats.dart';
import 'package:core/core.dart';

class BotCreatedEvent extends Event<BotEntity> {
  BotCreatedEvent({required super.data})
    : super(type: WebsocketMessageTypes.botCreated);
}
