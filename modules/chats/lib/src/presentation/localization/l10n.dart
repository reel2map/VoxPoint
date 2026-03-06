import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:intl/intl.dart';

class ChatsI18n {
  static String get search =>
      Intl.message('Search', desc: 'Search', name: 'ChatsI18n_search');

  static String get agents =>
      Intl.message('Agents', desc: 'Agents', name: 'ChatsI18n_agents');

  static String get agent =>
      Intl.message('Agent', desc: 'Agent', name: 'ChatsI18n_agent');

  static String get user =>
      Intl.message('User', desc: 'User', name: 'ChatsI18n_user');

  static String get sessions =>
      Intl.message('Sessions', desc: 'Sessions', name: 'ChatsI18n_sessions');

  static String get session =>
      Intl.message('Session', desc: 'Session', name: 'ChatsI18n_session');

  static String get analytics =>
      Intl.message('Analytics', desc: 'Analytics', name: 'ChatsI18n_analytics');

  static String get dashboard =>
      Intl.message('Dashboard', desc: 'Dashboard', name: 'ChatsI18n_dashboard');

  static String get clear =>
      Intl.message('Clear', desc: 'Clear', name: 'ChatsI18n_clear');

  static String get accept =>
      Intl.message('Accept', desc: 'Accept', name: 'ChatsI18n_accept');

  static String get decline =>
      Intl.message('Decline', desc: 'Decline', name: 'ChatsI18n_decline');

  static String get status =>
      Intl.message('Status', desc: 'Status', name: 'ChatsI18n_status');

  static String botStatusType(BotStatus value) => Intl.select(
    value,
    {
      BotStatus.error: 'Error',
      BotStatus.running: 'Running',
      BotStatus.starting: 'Starting',
      BotStatus.stopped: 'Stopped',
      BotStatus.stopping: 'Stopping',
      'other': '',
    },
    name: 'ChatsI18n_botStatusType',
    args: [value],
  );

  static String get all =>
      Intl.message('All', desc: 'All', name: 'ChatsI18n_all');

  static String get communicationChannel => Intl.message(
    'Channel',
    desc: 'Communication channel',
    name: 'ChatsI18n_communicationChannel',
  );

  static String get filter => Intl.message('Filter', name: 'ChatsI18n_filter');

  static String get messageCount =>
      Intl.message('Message count', name: 'ChatsI18n_messageCount');

  static String get selectOperator =>
      Intl.message('Select operator', name: 'ChatsI18n_selectOperator');

  static String get results =>
      Intl.message('Results', desc: 'Results', name: 'ChatsI18n_results');

  static String get parameters => Intl.message(
    'Parameters',
    desc: 'Parameters',
    name: 'ChatsI18n_parameters',
  );

  static String get takeOver =>
      Intl.message('Take Over', desc: 'Take Over', name: 'ChatsI18n_takeOver');

  static String get run =>
      Intl.message('Run', desc: 'Run', name: 'ChatsI18n_run');

  static String get stop =>
      Intl.message('Stop', desc: 'Stop', name: 'ChatsI18n_stop');

  static String get totalUniqueUserCount => Intl.message(
    'Unique users',
    desc: 'Total Unique User Count',
    name: 'ChatsI18n_totalUniqueUserCount',
  );

  static String get uniqueUsers => Intl.message(
    'Unique users',
    desc: 'Unique users',
    name: 'ChatsI18n_uniqueUsers',
  );

  static String get averageMessageVolumePerSession => Intl.message(
    'Avg. messages per session',
    desc: 'Avg. messages per session',
    name: 'ChatsI18n_averageMessageVolumePerSession',
  );

  static String get avgMessagesPerSession => Intl.message(
    'Avg. messages per session',
    desc: 'Avg. messages per session',
    name: 'ChatsI18n_avgMessagesPerSession',
  );

  static String get operatorSessionBreakdown => Intl.message(
    'Sessions with operator',
    desc: 'Operator Session Breakdown',
    name: 'ChatsI18n_operatorSessionBreakdown',
  );

  static String get transferredToOperator => Intl.message(
    'Transferred to operator',
    desc: 'Transferred to operator',
    name: 'ChatsI18n_transferredToOperator',
  );

  static String get answeredByOperator => Intl.message(
    'Answered by operator',
    desc: 'Answered by operator',
    name: 'ChatsI18n_answeredByOperator',
  );

  static String get resolvedByOperator => Intl.message(
    'Resolved by operator',
    desc: 'Resolved by operator',
    name: 'ChatsI18n_resolvedByOperator',
  );

  static String get totalSessionVolume => Intl.message(
    'Sessions',
    desc: 'Sessions',
    name: 'ChatsI18n_totalSessionVolume',
  );

  static String get totalSessions => Intl.message(
    'Total sessions',
    desc: 'Total sessions',
    name: 'ChatsI18n_totalSessions',
  );

  static String get answered =>
      Intl.message('Answered', name: 'ChatsI18n_answered');

  static String get period =>
      Intl.message('Period', desc: 'Period', name: 'ChatsI18n_period');

  static String periodType(PeriodType value) => Intl.select(
    value,
    {
      PeriodType.week: 'Daily',
      PeriodType.month: 'Weekly',
      PeriodType.year: 'Monthly',
      'other': '',
    },
    name: 'ChatsI18n_periodType',
    args: [value],
  );

  static String get typeYourMessage => Intl.message(
    'Type your message',
    desc: 'Type your message',
    name: 'ChatsI18n_typeYourMessage',
  );

  static String get copiedToClipboard => Intl.message(
    'Copied to clipboard',
    desc: 'Copied to clipboard',
    name: 'ChatsI18n_copiedToClipboard',
  );

  static String get total =>
      Intl.message('Total', desc: 'Total', name: 'ChatsI18n_total');

  static String get max =>
      Intl.message('Max', desc: 'Max', name: 'ChatsI18n_max');

  static String get min =>
      Intl.message('Min', desc: 'Min', name: 'ChatsI18n_min');

  static String get handedOver => Intl.message(
    'Handed over',
    desc: 'Handed over',
    name: 'ChatsI18n_handedOver',
  );

  static String get resolved =>
      Intl.message('Resolved', desc: 'Resolved', name: 'ChatsI18n_resolved');

  static String get startedConversation => Intl.message(
    'Started conversation',
    desc: 'Started conversation',
    name: 'ChatsI18n_startedConversation',
  );

  static String get userInfo =>
      Intl.message('User Info', desc: 'User Info', name: 'ChatsI18n_userInfo');

  static String get name =>
      Intl.message('Name', desc: 'Name', name: 'ChatsI18n_name');

  static String get type =>
      Intl.message('Type', desc: 'Type', name: 'ChatsI18n_type');

  static String get extId =>
      Intl.message('Ext ID', desc: 'Ext ID', name: 'ChatsI18n_extId');

  static String get takeOverConversation => Intl.message(
    'Take over the conversation',
    desc: 'Take over the conversation',
    name: 'ChatsI18n_takeOverConversation',
  );

  static String get takeOverConversationDescription => Intl.message(
    'Are you sure you want to take over the conversation with the AI assistant and continue the chat with the client on your own?',
    desc:
        'Are you sure you want to take over the conversation with the AI assistant and continue the chat with the client on your own?',
    name: 'ChatsI18n_takeOverConversationDescription',
  );

  static String get ok => Intl.message('OK', desc: 'OK', name: 'ChatsI18n_ok');

  static String get cancel =>
      Intl.message('Cancel', desc: 'Cancel', name: 'ChatsI18n_cancel');

  static String get startingAgent => Intl.message(
    'Starting the agent',
    desc: 'Starting the agent',
    name: 'ChatsI18n_startingAgent',
  );

  static String get startingAgentDescription => Intl.message(
    'Are you sure you want to start the agent?',
    desc: 'Are you sure you want to start the agent?',
    name: 'ChatsI18n_startingAgentDescription',
  );

  static String get stoppingAgent => Intl.message(
    'Stopping agent',
    desc: 'Stopping agent',
    name: 'ChatsI18n_stoppingAgent',
  );

  static String get stoppingAgentDescription => Intl.message(
    'Are you sure you want to stop the agent?',
    desc: 'Are you sure you want to stop the agent?',
    name: 'ChatsI18n_stoppingAgentDescription',
  );

  static String get addToContacts => Intl.message(
    'Add to contacts',
    desc: 'Add to contacts',
    name: 'ChatsI18n_addToContacts',
  );

  static String get share =>
      Intl.message('Share', desc: 'Share', name: 'ChatsI18n_share');

  static String get campaigns =>
      Intl.message('Campaigns', desc: 'Campaigns', name: 'ChatsI18n_campaigns');

  static String get statusDistribution => Intl.message(
    'Status Distribution by Period',
    desc: 'Status Distribution by Period',
    name: 'ChatsI18n_statusDistribution',
  );

  static String get stageDistribution => Intl.message(
    'Stage Distribution by Period',
    desc: 'Stage Distribution by Period',
    name: 'ChatsI18n_stageDistribution',
  );

  static String get selectCampaign => Intl.message(
    'Select a campaign',
    desc: 'Select a campaign',
    name: 'ChatsI18n_selectCampaign',
  );

  static String get unknownError => Intl.message(
    'Unknown error',
    desc: 'Unknown error',
    name: 'ChatsI18n_unknownError',
  );

  static String get count => Intl.message('Count', name: 'ChatsI18n_count');

  static String get noResults =>
      Intl.message('No results found', name: 'ChatsI18n_noResults');

  static String selectLogsCountOp(String type) => Intl.select(type, {
    'EQUAL': 'Equal',
    'NOT_EQUAL': 'Not equal',
    'MORE_THAN': 'Greater than',
    'LESS_THAN': 'Less than',
    'MORE_THAN_OR_EQUAL': 'Greater than or equal',
    'LESS_THAN_OR_EQUAL': 'Less than or equal',
  }, name: 'ChatsI18n_selectLogsCountOp');

  static String pushNotifications(MobilePushConfigSettings value) =>
      Intl.select(
        value,
        {
          MobilePushConfigSettings.newSession: 'Start conversation',
          MobilePushConfigSettings.messageFormHuman: 'New client message',
          MobilePushConfigSettings.transferredToOperator:
              'Transfer to operator',

          'other': '',
        },
        name: 'ChatsI18n_pushNotifications',
        args: [value],
      );

  static String get clientPushNotification => Intl.message(
    'Client push notification',
    desc: 'Client push notification',
    name: 'ChatsI18n_clientPushNotification',
  );

  static String get resolve =>
      Intl.message('Resolve', desc: 'Resolve', name: 'ChatsI18n_resolve');

  static String get reply =>
      Intl.message('Reply', desc: 'Reply', name: 'ChatsI18n_reply');

  static String get confirm =>
      Intl.message('Confirm', desc: 'Reply', name: 'ChatsI18n_confirm');

  static String get confirmDescription => Intl.message(
    'Are you sure you want to close this session and mark as resolved?',
    desc: 'Reply',
    name: 'ChatsI18n_confirmDescription',
  );

  static String get draftFromCopilot => Intl.message(
    'Draft from Copilot',
    desc: 'Draft from Copilot',
    name: 'ChatsI18n_draftFromCopilot',
  );

  static String get joinConversation => Intl.message(
    'Join Conversation',
    desc: 'Join Conversation',
    name: 'ChatsI18n_joinConversation',
  );

  static String get joinConversationDescription => Intl.message(
    'This session was transferred to operator. Do you want to join the conversation?',
    desc:
        'This session was transferred to operator. Do you want to join the conversation?',
    name: 'ChatsI18n_joinConversationDescription',
  );

  static String get copilot =>
      Intl.message('Copilot', desc: 'Copilot', name: 'ChatsI18n_copilot');
}
