import 'package:app/src/core/_core.dart';
import 'package:core/core.dart';

class MainFailure extends Failure {
  MainFailure({required super.code, required super.message});

  @override
  String getLocalizedString() {
    switch (code) {
      case 500:
        return CoreI18n.internalError;
      default:
        return CoreI18n.unknownError;
    }
  }
}
