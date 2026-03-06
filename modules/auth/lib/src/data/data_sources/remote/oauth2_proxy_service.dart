import 'package:dependencies/dependencies.dart';

abstract class OAuth2ProxyService {
  Future<void> authenticate();
}

@Injectable(as: OAuth2ProxyService)
class OAuth2ProxyServiceImpl implements OAuth2ProxyService {
  OAuth2ProxyServiceImpl({required this.dio});

  final Dio dio;

  @override
  Future<void> authenticate() async {}
}
