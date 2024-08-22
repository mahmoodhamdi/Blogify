import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:dartz/dartz.dart';
 
abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
}
