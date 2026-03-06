abstract class WebsocketMessageTypes {
  static const botCreated = 'BOT_CREATED';
  static const botModified = 'BOT_MODIFIED';
  static const botStatusModified = 'BOT_STATUS_MODIFIED';
  static const botDeleted = 'BOT_DELETED';
  static const sessionCreated = 'SESSION_CREATED';
  static const sessionClosed = 'SESSION_CLOSED';
  static const sessionUpdated = 'SESSION_UPDATED';
  static const sessionMovedToOperator = 'SESSION_MOVED_TO_OPERATOR';
  static const sessionNewMessage = 'SESSION_NEW_MESSAGE';
  static const sessionMessageModified = 'SESSION_MESSAGE_MODIFIED';
  static const billingSubscriptionCreated = 'BILLING_SUBSCRIPTION_CREATED';
  static const billingSubscriptionModified = 'BILLING_SUBSCRIPTION_MODIFIED';
  static const billingSubscriptionDeleted = 'BILLING_SUBSCRIPTION_DELETED';
}
