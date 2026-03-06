import 'package:dependencies/dependencies.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R? getRight() => fold<R?>((_) => null, (R r) => r);
  L? getLeft() => fold<L?>((L l) => l, (_) => null);
}
