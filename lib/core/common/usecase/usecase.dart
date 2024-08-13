import 'package:dartz/dartz.dart';

abstract interface class Usecase<Success, Params> {
  Future<Either<Exception, Success>> call(Params params);
}
