import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

abstract class BotRepository {
  Future<Either<Failure, List<BotEntity>>> getBots({
    String? tenantId,
    bool? isRunning,
    int? limit,
    int? skip,
  });

  Future<Either<Failure, BotEntity>> getBot({
    required String botId,
    String? tenantId,
  });

  Future<Either<Failure, BotStatusEntity>> action({
    required String botId,
    required BotActionEntity action,
  });

  Future<Either<Failure, SupportBotEntity>> getSupportBot();
}
