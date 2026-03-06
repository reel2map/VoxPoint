import 'package:app/src/features/home/_home.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

// ignore: one_member_abstracts
abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHome();
}
