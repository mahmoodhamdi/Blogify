import 'package:blogify/core/error/failures.dart';
import 'package:dartz/dartz.dart';
 
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
