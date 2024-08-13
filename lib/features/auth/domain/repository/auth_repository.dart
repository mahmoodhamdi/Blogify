import 'package:blogify/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepository {
  Future<Either<AppException, String>> signUpWithEmailAndPassword({required String name,required String email,required String password});
  Future<Either<AppException, String>> loginWithEmailAndPassword({required String email,required String password});
}
