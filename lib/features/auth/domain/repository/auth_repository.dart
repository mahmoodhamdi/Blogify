import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepository {
  Future<Either<AppException, UserEntity>> signUpWithEmailAndPassword({required String name,required String email,required String password});
  Future<Either<AppException,  UserEntity>> loginWithEmailAndPassword({required String email,required String password});
}
