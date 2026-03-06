import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_log_data_source.g.dart';

@RestApi()
abstract class RestLogDataSource {
  factory RestLogDataSource(Dio dio) = _RestLogDataSource;

  @POST(ChatApiMethods.newLog)
  @MultiPart()
  Future<void> newLog({
    @Header('Authorization') required String botToken,
    @Path('session_id') required String sessionId,
    @Path('bot_id') required String botId,
    @Part(name: 'role') required String role,
    @Part(name: 'message') required String message,
    // TODO: need docs
    //@Part(name: 'attachments') required List<File> files,
  });

  @PUT(ChatApiMethods.setSessionMode)
  Future<void> setOperatorMode({
    @Header('Authorization') required String botToken,
    @Path('session_id') required String sessionId,
    @Path('bot_id') required String botId,
    @Body() required Map<String, dynamic> request,
  });
}
