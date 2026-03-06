import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@Injectable(as: BotRepository)
class BotRepositoryImpl implements BotRepository {
  BotRepositoryImpl({required RestBotDataSource restBotDataSource})
    : _restBotDataSource = restBotDataSource;

  final RestBotDataSource _restBotDataSource;

  @override
  Future<Either<Failure, BotEntity>> getBot({
    required String botId,
    String? tenantId,
  }) async {
    try {
      final result = await _restBotDataSource.getBot(
        botId: botId,
        tenantId: tenantId,
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BotFailure(code: 0, message: ''));
      }

      return Left(BotFailure(code: e.response?.statusCode ?? 0, message: ''));
    } catch (e) {
      return Left(BotFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BotEntity>>> getBots({
    String? tenantId,
    bool? isRunning,
    int? limit,
    int? skip,
  }) async {
    try {
      final result = await _restBotDataSource.getBots(
        tenantId: tenantId,
        isRunning: isRunning,
        limit: limit,
        skip: skip,
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BotFailure(code: 0, message: ''));
      }

      return Left(BotFailure(code: e.response?.statusCode ?? 0, message: ''));
    } catch (e) {
      return Left(BotFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BotStatusEntity>> action({
    required String botId,
    required BotActionEntity action,
  }) async {
    try {
      final result = await _restBotDataSource.action(
        botId: botId,
        action: action,
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BotFailure(code: 0, message: ''));
      }

      return Left(BotFailure(code: e.response?.statusCode ?? 0, message: ''));
    } catch (e) {
      return Left(BotFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportBotEntity>> getSupportBot() async {
    try {
      final envs = await _restBotDataSource.getEnvironments(
        names: 'FLAMETREE_SUPPORT_BOT_ID,FLAMETREE_SUPPORT_BOT_TOKEN',
      );

      final id = envs.firstWhereOrNull(
        (e) => e.name == 'FLAMETREE_SUPPORT_BOT_ID',
      );

      final token = envs.firstWhereOrNull(
        (e) => e.name == 'FLAMETREE_SUPPORT_BOT_TOKEN',
      );

      if (id == null || token == null) {
        return Left(BotFailure(code: 0, message: 'not found'));
      }

      return Right(
        SupportBotEntity(id: id.value ?? '', token: token.value ?? ''),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(BotFailure(code: 0, message: ''));
      }

      return Left(BotFailure(code: e.response?.statusCode ?? 0, message: ''));
    } catch (e) {
      return Left(BotFailure(code: 0, message: e.toString()));
    }
  }
}
