import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:fresh_dio/fresh_dio.dart';

@injectable
class AuthStorage implements TokenStorage<OAuth2Token> {
  AuthStorage({required SecureStorage storage}) : _storage = storage;

  final SecureStorage _storage;

  final String _tokenKey = 'token';
  final String _refreshTokenKey = 'refreshToken';
  final String _currentUserKey = 'current_user';
  final String _blockUserDurationKey = 'block_user_duration';

  Future<bool> get hasToken => _storage.containsKey(_tokenKey);

  Future<bool> get hasRefreshToken => _storage.containsKey(_refreshTokenKey);

  Future<void> setToken(String value) {
    return _storage.write(_tokenKey, value);
  }

  Future<void> setRefreshToken(String value) {
    return _storage.write(_refreshTokenKey, value);
  }

  Future<void> removeToken() {
    return _storage.delete(_tokenKey);
  }

  Future<String?> getToken() {
    return _storage.read(_tokenKey);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(_refreshTokenKey);
  }

  Future<void> deleteRefreshToken() {
    return _storage.delete(_refreshTokenKey);
  }

  Future<void> saveCurrentUser(String value) {
    return _storage.write(_currentUserKey, value);
  }

  Future<String?> getCurrentUser() async {
    return _storage.read(_currentUserKey);
  }

  Future<void> removeCurrentUser() async {
    return _storage.delete(_currentUserKey);
  }

  Future<void> blockUser(DateTime value) {
    return _storage.write(_blockUserDurationKey, value.toString());
  }

  Future<void> unBlockUser() {
    return _storage.delete(_blockUserDurationKey);
  }

  Future<DateTime?> getBlockTime() async {
    final String? value = await _storage.read(_blockUserDurationKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  @override
  Future<void> delete() async {
    await removeToken();
    await deleteRefreshToken();
  }

  @override
  Future<OAuth2Token?> read() async {
    final accessToken = await getToken();
    final refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }
    //TODO: expires
    return OAuth2Token(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> write(OAuth2Token token) async {
    await setToken(token.accessToken);
    await setRefreshToken(token.refreshToken ?? '');
  }
}
