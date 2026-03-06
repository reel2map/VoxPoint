import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

abstract class SessionsRepository {
  Future<Either<Failure, List<SessionEntity>>> getSessions({
    required String tenantId,
    int? skip,
    int? limit,
    SessionFilter filter,
  });

  Future<Either<Failure, SessionEntity>> getSession({
    required String tenantId,
    required String sessionId,
  });

  Future<Either<Failure, List<LogEntity>>> getSessionLogs({
    required String tenantId,
    required String sessionId,
    int? skip,
    int? limit,
  });

  Future<Either<Failure, Map<String, dynamic>>> getConversationResults({
    required String tenantId,
    required String sessionId,
  });

  Future<Either<Failure, List<DashboardAgentPeriodEntity>>> getAgentsDashboard({
    required String tenantId,
    required PeriodType period,
    List<String>? botIds,
  });

  Future<Either<Failure, List<DashboardCampaignPeriodEntity>>>
  getCampaignDashboard({
    required String tenantId,
    required PeriodType period,
    required String campaignId,
  });

  Future<Either<Failure, SessionEntity>> setSessionMode({
    required String tenantId,
    required BotEntity bot,
    required String sessionId,
    required String operatorId,
    required SessionType sessionType,
  });

  Future<Either<Failure, void>> sendMessage({
    required String sessionId,
    required String botId,
    required String message,
    required String botToken,
  });

  Future<Either<Failure, List<SessionUserEntity>>> getSessionUsers({
    required String tenantId,
  });

  Future<Either<Failure, List<CampaignEntity>>> getCampaigns({
    required String tenantId,
  });

  Future<Either<Failure, void>> resolve({
    required String botId,
    required String sessionId,
    required String status,
  });
}
