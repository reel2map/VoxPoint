import 'package:dependencies/dependencies.dart';

abstract class OAuthService {
  Future<TokenResponse> authenticate();
  Future<TokenResponse> refreshToken(String refreshToken);
  Future<EndSessionResponse> logout();
}
