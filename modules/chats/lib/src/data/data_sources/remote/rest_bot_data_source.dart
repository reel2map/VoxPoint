import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_bot_data_source.g.dart';

@Injectable()
@RestApi()
abstract class RestBotDataSource {
  @factoryMethod
  factory RestBotDataSource(Dio dio) = _RestBotDataSource;

  @GET(ChatApiMethods.bots)
  Future<List<BotEntity>> getBots({
    @Query('tenant_id') String? tenantId,
    @Query('is_running') bool? isRunning,
    @Query('skip') int? skip,
    @Query('limit') int? limit,
  });

  @GET(ChatApiMethods.bot)
  Future<BotEntity> getBot({
    @Path('bot_id') required String botId,
    @Query('tenant_id') String? tenantId,
  });

  @POST(ChatApiMethods.bot)
  Future<BotStatusEntity> action({
    @Path('bot_id') required String botId,
    @Body() required BotActionEntity action,
  });

  @GET(ChatApiMethods.environments)
  Future<List<EnvironmentDto>> getEnvironments({@Query('names') String? names});
}
