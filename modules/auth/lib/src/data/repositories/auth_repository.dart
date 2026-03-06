import 'dart:async';
import 'dart:convert';

import 'package:auth/src/_src.dart';
import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:settings/settings.dart';

@Injectable(as: AuthRepository<AuthModel, UserEntity>)
class AuthRepositoryImpl implements AuthRepository<AuthModel, UserEntity> {
  AuthRepositoryImpl({
    required RestAuthDataSource restAuthDataSource,
    required OAuthService oAuthService,
    required AuthStorage storage,
    required UserSecurityStorage userSecurityStorage,
    required Talker logger,
    required CookieJar cookieJar,
  }) : _restAuthDataSource = restAuthDataSource,
       _oAuthService = oAuthService,
       _storage = storage,
       _userSecurityStorage = userSecurityStorage,
       _logger = logger,
       _cookieJar = cookieJar;

  final RestAuthDataSource _restAuthDataSource;
  final AuthStorage _storage;
  final UserSecurityStorage _userSecurityStorage;
  final OAuthService _oAuthService;
  final CookieJar _cookieJar;
  final Talker _logger;

  @override
  Future<bool> comparePinCode(String value) {
    return _userSecurityStorage.comparePinCode(value);
  }

  @override
  Future<void> deleteAccessToken() {
    return _storage.removeToken();
  }

  @override
  Future<void> deletePinCode() {
    return _userSecurityStorage.removePinCode();
  }

  @override
  Future<void> deleteUseBiometric() {
    return _userSecurityStorage.removeUseBiometric();
  }

  @override
  Future<String?> getAccessToken() {
    return _storage.getToken();
  }

  @override
  Future<bool> hasAccessToken() async {
    return _storage.hasToken;
  }

  @override
  Future<bool> hasPinCode() {
    return _userSecurityStorage.hasPinCode;
  }

  @override
  Future<void> setAccessToken(String value) {
    return _storage.setToken(value);
  }

  @override
  Future<void> setPinCode(String value) {
    return _userSecurityStorage.setPinCode(value);
  }

  @override
  Future<void> setUseBiometric({required bool value}) {
    return _userSecurityStorage.setUseBiometric(value);
  }

  @override
  Future<void> setUseLocalAuth(bool value) {
    return _userSecurityStorage.setUseLocalAuth(value);
  }

  @override
  Future<bool?> useLocalAuth() {
    return _userSecurityStorage.getUseLocalAuth();
  }

  @override
  Future<void> deleteUseLocalAuth() {
    return _userSecurityStorage.removeUseLocalAuth();
  }

  @override
  Future<Either<Failure, AuthModel>> signIn(
    String login,
    String password,
  ) async {
    throw UnimplementedError();
  }

  Future<void> oAuthLogout() async {
    try {
      await _oAuthService.logout();
    } catch (e, stackTrace) {
      _logger.debug(e.toString(), e, stackTrace);
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      unawaited(oAuthLogout());

      await _storage.removeCurrentUser();

      return const Right(true);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(AuthFailure(code: 0, message: ''));
      }

      await _storage.removeCurrentUser();

      return Left(AuthFailure(code: e.response?.statusCode ?? 0, message: ''));
    } catch (e) {
      await _storage.removeCurrentUser();

      return Left(AuthFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> verify({String? deviceId}) async {
    try {
      final result = await _restAuthDataSource.verify(deviceId: deviceId);

      await _storage.saveCurrentUser(jsonEncode(result.toJson()));

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return Left(
          AuthFailure(code: 0, message: e.message ?? e.error.toString()),
        );
      }

      return Left(
        AuthFailure(
          code: e.response?.statusCode ?? 0,
          message: e.message ?? e.error.toString(),
        ),
      );
    } catch (e) {
      return Left(AuthFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> getCurrentUser() async {
    try {
      final user = await _storage.getCurrentUser();

      if (user != null) {
        return Right(AuthenticatedUser.fromJson(jsonDecode(user)));
      }

      return Left(AuthFailure(code: 0, message: 'User not found'));
    } catch (e) {
      return Left(AuthFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentUser(UserEntity user) async {
    try {
      await _storage.saveCurrentUser(jsonEncode(user));

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(code: 0, message: ''));
    }
  }

  @override
  Future<void> blockUser(DateTime value) {
    return _storage.blockUser(value);
  }

  @override
  Future<void> unBlocUser() {
    return _storage.unBlockUser();
  }

  @override
  Future<DateTime?> getBlockTime() async {
    return _storage.getBlockTime();
  }

  @override
  Future<Either<Failure, AuthModel>> signInOAuth() async {
    try {
      final result = await _oAuthService.authenticate();

      if (result.accessToken == null || result.refreshToken == null) {
        return Left(AuthFailure(code: 0, message: ''));
      }

      await _storage.setToken(result.accessToken!);

      await _storage.setRefreshToken(result.refreshToken!);

      _logger.log(
        'token = ${result.accessToken}\nrefresh token = ${result.refreshToken}',
      );

      final _deviceInfo = await AppInfo.getDeviceInfo();

      final user = await _restAuthDataSource.verify(
        deviceId: _deviceInfo.deviceId,
      );

      await _storage.saveCurrentUser(jsonEncode(user.toJson()));

      return Right(AuthModel(token: '', refreshToken: '', user: user));
    } catch (e) {
      return Left(AuthFailure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<void> deleteRefreshToken() {
    // TODO: implement deleteRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> setRefreshToken(String value) {
    // TODO: implement setRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteCurrentUser() async {
    return Right(await _storage.removeCurrentUser());
  }

  @override
  Future<bool> hasCookies() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(Env.apiUrl));
    return cookies.isNotEmpty;
  }
}
