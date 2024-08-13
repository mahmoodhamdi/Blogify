import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/data/data_sources/remote_data_source.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<AppException, String>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
   return await remoteDataSource.signUpWithEmailAndPassword(
        name: name, email: email, password: password);
  }

  @override
  Future<Either<AppException, String>> loginWithEmailAndPassword(
      {required String email, required String password}) async{
    return await remoteDataSource.loginWithEmailAndPassword(
        email: email, password: password);
  }
}