import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@injectable
class WebsocketMessageHandler {
  WebsocketMessageHandler({required this.eventBus, required this.logger});

  final EventBus eventBus;

  final Talker logger;

  final _mapper = {
    WebsocketMessageTypes.botCreated:
        (Map<String, dynamic> data) =>
            BotCreatedEvent(data: BotEntity.fromJson(data)),
    WebsocketMessageTypes.botModified:
        (Map<String, dynamic> data) =>
            BotModifiedEvent(data: BotEntity.fromJson(data)),
    WebsocketMessageTypes.botStatusModified:
        (Map<String, dynamic> data) =>
            BotStatusModifiedEvent(data: BotEntity.fromJson(data)),
    WebsocketMessageTypes.botDeleted:
        (Map<String, dynamic> data) =>
            BotDeletedEvent(data: BotEntity.fromJson(data)),
    WebsocketMessageTypes.sessionCreated:
        (Map<String, dynamic> data) =>
            SessionCreatedEvent(data: SessionEntity.fromJson(data)),
    WebsocketMessageTypes.sessionClosed:
        (Map<String, dynamic> data) =>
            SessionClosedEvent(data: SessionEntity.fromJson(data)),
    WebsocketMessageTypes.sessionUpdated:
        (Map<String, dynamic> data) =>
            SessionUpdatedEvent(data: SessionEntity.fromJson(data)),
    WebsocketMessageTypes.sessionMovedToOperator:
        (Map<String, dynamic> data) =>
            SessionMovedToOperatorEvent(data: SessionEntity.fromJson(data)),
    WebsocketMessageTypes.sessionNewMessage:
        (Map<String, dynamic> data) =>
            SessionNewMessageEvent(data: LogEntity.fromJson(data)),
    WebsocketMessageTypes.sessionMessageModified:
        (Map<String, dynamic> data) =>
            SessionMessageModifiedEvent(data: LogEntity.fromJson(data)),
    WebsocketMessageTypes.billingSubscriptionCreated:
        (Map<String, dynamic> data) =>
            BillingSubscriptionCreated(data: SubscriptionEntity.fromJson(data)),
    WebsocketMessageTypes.billingSubscriptionModified:
        (Map<String, dynamic> data) => BillingSubscriptionModified(
          data: SubscriptionEntity.fromJson(data),
        ),
    WebsocketMessageTypes.billingSubscriptionDeleted:
        (Map<String, dynamic> data) =>
            BillingSubscriptionDeleted(data: SubscriptionEntity.fromJson(data)),
    null: (data) {},
  };

  void handler(String message) {
    final data = jsonDecode(message);

    if (data is! Map) {
      return;
    }

    final action = data['action'];
    try {
      if (data['data'] != null) {
        eventBus.fire(
          _mapper[action]?.call(data['data'] as Map<String, dynamic>),
        );
      }
    } on Exception catch (e, stacktrace) {
      logger.logCustom(
        TalkerLog(
          'WebsocketMessageHandler error',
          exception: e,
          stackTrace: stacktrace,
          title: 'websocket',
        ),
      );
    }
  }
}
