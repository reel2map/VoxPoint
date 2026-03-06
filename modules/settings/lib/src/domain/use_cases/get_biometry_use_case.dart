import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:settings/src/_src.dart';

@injectable
class GetBiometryUseCase implements UseCaseNoParams<bool> {
  GetBiometryUseCase(this._biometricRepository);

  final BiometricRepository _biometricRepository;

  @override
  Future<bool> call() async {
    return _biometricRepository.getUseBiometric();
  }
}
