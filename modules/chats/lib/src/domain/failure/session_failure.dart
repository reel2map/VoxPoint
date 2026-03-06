import 'package:core/core.dart';

class SessionFailure extends Failure {
  SessionFailure({required super.code, required super.message});

  @override
  String getLocalizedString() {
    switch (code) {
      case 500:
        return 'Unknown Error';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Bot not found';
      case 503:
        return 'Service unavailable';

      default:
        return 'unknownError';
    }
  }
}
