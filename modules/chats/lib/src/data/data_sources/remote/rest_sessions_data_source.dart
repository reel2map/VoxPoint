import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_sessions_data_source.g.dart';

@Injectable()
@RestApi()
abstract class RestSessionsDataSource {
  @factoryMethod
  factory RestSessionsDataSource(Dio dio) = _RestSessionsDataSource;

  @GET(ChatApiMethods.sessions)
  Future<SessionsDto> getSessions({
    @Query('bot_id') String? botId,
    @Query('user_id') String? userId,
    @Query('user_type') String? userType,
    @Query('skip') int? skip,
    @Query('limit') int? limit,
    @Query('country_code') String? countryCode,
    @Query('ip') String? ip,
    @Query('start_time') String? startTime,
    @Query('finish_time') String? finishTime,
    @Query('tenant_id') String? tenantId,
    @Query('logs_count') String? logsCount,
    @Query('is_operator') bool? isOperator,
    @Query('is_active') bool? isActive,
    @Query('contact_id') String? contactId,
    @Query('operator_id') String? operatorId,
    @Query('logs_count_op') String? logCountOperator,
    @Query('user_search') String? userSearch,
    @Query('start_time_from') String? startTimeFrom,
    @Query('start_time_to') String? startTimeTo,
    @Query('last_message_time_from') String? lastMessageTimeFrom,
    @Query('last_message_time_to') String? lastMessageTimeTo,
  });

  @GET(ChatApiMethods.session)
  Future<SessionEntity> getSession({
    @Path('session_id') required String sessionId,
    @Query('tenant_id') String? tenantId,
  });

  @GET(ChatApiMethods.logs)
  Future<LogsDto> getLogs({
    @Path('session_id') required String sessionId,
    @Query('tenant_id') String? tenantId,
  });

  @GET(ChatApiMethods.conversationResult)
  Future<String> getConversationResults({
    @Path('session_id') required String sessionId,
    @Query('tenant_id') String? tenantId,
  });

  @POST(ChatApiMethods.dashboard)
  Future<DashboardAgentResponseDto> getAgentDashboard({
    @Path('tenant_id') required String tenantId,
    @Body() required DashboardAgentRequestDto request,
  });

  @POST(ChatApiMethods.dashboard)
  Future<DashboardCampaignResponseDto> getCampaignDashboard({
    @Path('tenant_id') required String tenantId,
    @Body() required DashboardCampaignRequestDto request,
  });

  @PATCH(ChatApiMethods.session)
  Future<SessionEntity> setSessionMode({
    @Path('session_id') required String sessionId,
    @Body() required SetSessionModeDto request,
    @Query('tenant_id') String? tenantId,
  });

  @GET(ChatApiMethods.sessionUsers)
  Future<SessionUsersDto> getSessionUsers({
    @Query('tenant_id') String? tenantId,
  });

  @GET(ChatApiMethods.campaigns)
  Future<CampaignsDto> getCampaigns({@Query('tenant_id') String? tenantId});

  @GET(ChatApiMethods.bot)
  Future<BotEntity> getBot({@Path('bot_id') required String botId});

  @DELETE(ChatApiMethods.chatbotSession)
  Future<void> resolve({
    @Path('session_id') required String sessionId,
    @Path('bot_id') required String botId,
    @Header('Authorization') required String botToken,
    @Query('status') String? status,
  });
}
