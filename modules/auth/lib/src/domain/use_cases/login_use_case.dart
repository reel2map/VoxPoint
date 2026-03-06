import 'dart:async';

import 'package:auth/src/_src.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

@injectable
class LoginUseCase implements UseCaseNoParams<Either<Failure, bool>> {
  LoginUseCase(this._authManager);

  final AuthManager<UserEntity> _authManager;

  @override
  Future<Either<Failure, bool>> call() async {
    return _authManager.signInOAuth();
  }
}
