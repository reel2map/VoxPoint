import 'dart:convert';

import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@Injectable(as: SessionsRepository)
class SessionsRepositoryImpl implements SessionsRepository {
  SessionsRepositoryImpl({
    required RestSessionsDataSource restSessionsDataSource,
    required RestLogDataSource restLogDataSource,
  }) : _restSessionsDataSource = restSessionsDataSource,
       _restLogDataSource = restLogDataSource;

  final RestSessionsDataSource _restSessionsDataSource;

  final RestLogDataSource _restLogDataSource;

  @override
  Future<Either<Failure, List<SessionEntity>>> getSessions({
    required String tenantId,
    int? limit,
    int? skip,
    SessionFilter? filter,
  }) async {
    try {
      final result = await _restSessionsDataSource.getSessions(
        tenantId: tenantId,
        skip: skip,
        userId: filter?.sessionUserEntity?.id,
        limit: limit,
        userType: filter?.userType?.name,
        botId: filter?.bot?.id,
        userSearch: filter?.userSearch,
        logsCount: filter?.logsCount?.toString(),
        logCountOperator: filter?.logsCountOp,
        startTimeFrom: filter?.startTimeFrom,
        startTimeTo: filter?.startTimeTo,
        lastMessageTimeFrom: filter?.lastMessageTimeFrom,
        lastMessageTimeTo: filter?.lastMessageTimeTo,
      );

      return Right(result.sessions);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> getSession({
    required String tenantId,
    required String sessionId,
  }) async {
    try {
      final result = await _restSessionsDataSource.getSession(
        tenantId: tenantId,
        sessionId: sessionId,
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LogEntity>>> getSessionLogs({
    required String tenantId,
    required String sessionId,
    int? skip,
    int? limit,
  }) async {
    try {
      final result = await _restSessionsDataSource.getLogs(
        tenantId: tenantId,
        sessionId: sessionId,
      );

      return Right(result.logs);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getConversationResults({
    required String tenantId,
    required String sessionId,
  }) async {
    try {
      final result = await _restSessionsDataSource.getConversationResults(
        tenantId: tenantId,
        sessionId: sessionId,
      );

      return Right(jsonDecode(result) as Map<String, dynamic>? ?? {});
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DashboardAgentPeriodEntity>>> getAgentsDashboard({
    required String tenantId,
    required PeriodType period,
    List<String>? botIds,
  }) async {
    try {
      final result = await _restSessionsDataSource.getAgentDashboard(
        tenantId: tenantId,
        request: DashboardAgentRequestDto(period: period, botIds: botIds),
      );

      return Right(result.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> setSessionMode({
    required String tenantId,
    required BotEntity bot,
    required String sessionId,
    required String operatorId,
    required SessionType sessionType,
  }) async {
    try {
      await _restLogDataSource.setOperatorMode(
        botToken: 'Bearer ${bot.token ?? ''}',
        sessionId: sessionId,
        botId: bot.id,
        //  request: {'mode': 'OPERATOR'},
        request: {
          'mode': switch (sessionType) {
            SessionType.regular => 'REGULAR',

            SessionType.operator => 'OPERATOR',

            SessionType.copilot => 'COPILOT',

            SessionType.unknown => 'OPERATOR',
          },
        },
      );

      final result = await _restSessionsDataSource.setSessionMode(
        tenantId: tenantId,
        sessionId: sessionId,
        request: SetSessionModeDto(
          operatorId: operatorId,
          sessionType: sessionType,
        ),
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String sessionId,
    required String botId,
    required String message,
    required String botToken,
  }) async {
    try {
      await _restLogDataSource.newLog(
        botId: botId,
        botToken: 'Bearer $botToken',
        sessionId: sessionId,
        role: 'OPERATOR',
        message: message,
      );

      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SessionUserEntity>>> getSessionUsers({
    required String tenantId,
  }) async {
    try {
      final result = await _restSessionsDataSource.getSessionUsers(
        tenantId: tenantId,
      );

      return Right(result.users);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>> getCampaigns({
    required String tenantId,
  }) async {
    try {
      final result = await _restSessionsDataSource.getCampaigns(
        tenantId: tenantId,
      );

      return Right(result.campaigns);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DashboardCampaignPeriodEntity>>>
  getCampaignDashboard({
    required String tenantId,
    required PeriodType period,
    required String campaignId,
  }) async {
    try {
      final result = await _restSessionsDataSource.getCampaignDashboard(
        tenantId: tenantId,
        request: DashboardCampaignRequestDto(
          period: period,
          campaignId: campaignId,
        ),
      );

      return Right(result.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: ''));
      }

      return Left(
        SessionFailure(code: e.response?.statusCode ?? 0, message: ''),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolve({
    required String botId,
    required String sessionId,
    required String status,
  }) async {
    try {
      final bot = await _restSessionsDataSource.getBot(botId: botId);

      final result = await _restSessionsDataSource.resolve(
        botId: bot.id,
        sessionId: sessionId,
        status: status,
        botToken: 'Bearer ${bot.token}',
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(SessionFailure(code: 0, message: e.toString()));
      }

      return Left(
        SessionFailure(
          code: e.response?.statusCode ?? 0,
          message: e.toString(),
        ),
      );
    } catch (e) {
      return Left(SessionFailure(code: 0, message: e.toString()));
    }
  }
}
