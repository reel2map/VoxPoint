import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@Injectable(as: OAuthService)
class OAuthServiceImpl implements OAuthService {
  static final List<String> _scopes = ['openid', 'profile', 'email'];

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  AuthorizationTokenRequest get _authorizationTokenResponse =>
      AuthorizationTokenRequest(
        Env.oauth2ClientId,
        Env.oauth2RedirectUri,
        issuer: Env.oauth2Issuer,
        scopes: _scopes,
        discoveryUrl: '${Env.oauth2Issuer}/.well-known/openid-configuration',
      );

  @override
  Future<TokenResponse> refreshToken(String refreshToken) async {
    return _appAuth.token(
      TokenRequest(
        Env.oauth2ClientId,
        Env.oauth2RedirectUri,
        issuer: Env.oauth2Issuer,
        scopes: _scopes,
        discoveryUrl: '${Env.oauth2Issuer}/.well-known/openid-configuration',
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  Future<EndSessionResponse> logout() async {
    return _appAuth.endSession(
      EndSessionRequest(
        //   idTokenHint: idToken,
        issuer: Env.oauth2Issuer,
        discoveryUrl: '${Env.oauth2Issuer}/.well-known/openid-configuration',
      ),
    );
  }

  @override
  Future<TokenResponse> authenticate() async {
    return _appAuth.authorizeAndExchangeCode(_authorizationTokenResponse);
  }
}
