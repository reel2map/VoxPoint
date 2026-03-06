import 'package:auth/src/_src.dart';
import 'package:dependencies/dependencies.dart';

@Named('mock')
@Injectable(as: RestAuthDataSource)
class MockAuthDataSource implements RestAuthDataSource {
  Future<AuthModel> signIn({required Map<String, dynamic> request}) async {
    return AuthModel(
      token: 'token',
      refreshToken: 'refreshToken',
      user: AuthenticatedUser.empty,
    );
  }

  Future<void> signOut() async {}

  Future<void> updateDeviceInfo({
    required Map<String, dynamic> request,
  }) async {}

  @override
  Future<AuthenticatedUser> verify({String? deviceId}) async {
    return AuthenticatedUser.empty;
  }
}
