import 'package:app/src/features/main/_main.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

// ignore: one_member_abstracts
abstract class MainRepository {
  Future<Either<Failure, MainModel>> getMain();
}
