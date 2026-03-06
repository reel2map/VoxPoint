class ChatApiMethods {
  static const String bots = '/api/v1/bots';
  static const String bot = '/api/v1/bots/{bot_id}';
  static const String sessions = '/api/v1/sessions';
  static const String session = '/api/v1/sessions/{session_id}';
  static const String logs = '/api/v1/sessions/{session_id}/logs';
  static const String conversationResult =
      '/api/v1/sessions/{session_id}/conversation_result';
  static const String dashboard = '/api/v1/tenants/{tenant_id}/dashboard';
  static const String newLog = '/chatbot/{bot_id}/session/{session_id}/logs_v2';
  static const String setSessionMode = '/chatbot/{bot_id}/session/{session_id}';
  static const String chatbotSession = '/chatbot/{bot_id}/session/{session_id}';
  static const String sessionUsers = '/api/v1/sessions/users';
  static const String campaigns = '/api/v1/marketing/campaigns';
  static const String environments = '/api/v1/system/environments';
}
