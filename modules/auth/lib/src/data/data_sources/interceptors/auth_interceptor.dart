import 'dart:developer';
import 'dart:io';

import 'package:auth/src/_src.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor(AuthStorage storage, OAuthService oAuthService)
    : _storage = storage,
      _oAuthService = oAuthService;

  final AuthStorage _storage;

  final OAuthService _oAuthService;

  Function? onLogout;

  CancelToken? cancelToken;

  Future<String> getToken() async {
    if (await _storage.hasToken) {
      try {
        final token = await _storage.getToken() ?? '';
        final remainingDate = JwtDecoder.getRemainingTime(token);
        if (remainingDate.inSeconds < 60) {
          final success = await refreshToken();

          if (success) {
            return await _storage.getToken() ?? '';
          } else {
            throw Exception('Token not found');
          }
        } else {
          return token;
        }
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<bool> refreshToken() async {
    final hasRefreshToken = await _storage.hasRefreshToken;

    if (hasRefreshToken) {
      try {
        final refreshToken = await _storage.getRefreshToken() ?? '';

        final result = await _oAuthService.refreshToken(refreshToken);

        if (result.accessToken != null && result.refreshToken != null) {
          if (kDebugMode) {
            log('new token = ${result.accessToken}');

            log('new refreshToken = ${result.refreshToken}');
          }

          await _storage.setToken(result.accessToken ?? '');

          await _storage.setRefreshToken(result.refreshToken ?? '');
        }

        return true;
        //TODO: check exceptions
      } on FlutterAppAuthPlatformException catch (e) {
        //token_failed

        if (e.code == 'discovery_failed') {
          return false;
        }
        await _storage.removeToken();
        await _storage.deleteRefreshToken();

        //sl<EventBus>().fire(UserLoggedOutEvent(remote: false));
        sl<AuthManager<UserEntity>>().signOut(remote: false);
        return false;
      }
    } else {
      _cancelRequest();

      return false;
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasToken = await _storage.hasToken;

    /*options.headers.addAll(<String, String>{
      'x-device-id': (await AppInfo.getDeviceInfo()).deviceId,
    });*/

    if (hasToken) {
      try {
        var token = await _storage.getToken() ?? '';

        final remainingDate = JwtDecoder.getRemainingTime(token);

        if (remainingDate.inSeconds < 60) {
          final result = await refreshToken();

          if (result) {
            token = await _storage.getToken() ?? '';
          } else {
            _cancelRequest();

            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: 401,
                ),
              ),
            );
          }
        }
        if (!options.headers.containsKey(HttpHeaders.authorizationHeader)) {
          options.headers.addAll(<String, String>{
            HttpHeaders.authorizationHeader: 'Bearer $token',
          });
        }
      } catch (_) {
        return handler.next(options);
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      try {
        _cancelRequest();
        sl<AuthManager<UserEntity>>().signOut(remote: false);
      } catch (error) {}
    }

    return super.onError(err, handler);
  }

  void _cancelRequest() {
    cancelToken?.cancel();
  }
}
