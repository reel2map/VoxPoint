import 'package:chats/chats.dart';
import 'package:core/core.dart';

class BotModifiedEvent extends Event<BotEntity> {
  BotModifiedEvent({required super.data})
    : super(type: WebsocketMessageTypes.botModified);
}
