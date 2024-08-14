import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<Either<AppException, UserModel>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<Either<AppException, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;
  RemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<Either<AppException, UserModel>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final authResponse = await supabaseClient.auth
          .signUp(email: email, password: password, data: {'name': name});
      return Right(UserModel.fromJson(authResponse.user!.toJson()));
    } catch (e) {
      if (e is AuthException) {
        return Left(AppException.fromServerException(e.message));
      } else {
        return const Left(AppException());
      }
    }
  }

  @override
  Future<Either<AppException, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final authResponse = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      return Right(UserModel.fromJson(authResponse.user!.toJson()));
    } catch (e) {
      if (e is AuthException) {
        return Left(AppException.fromServerException(e.message));
      } else {
        return const Left(AppException());
      }
    }
  }
}
