import 'package:blogify/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<Either<AppException, String>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<Either<AppException, String>> loginWithEmailAndPassword(
      {required String email, required String password});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabase;
  RemoteDataSourceImpl({required this.supabase});
  @override
  Future<Either<AppException, String>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final authResponse = await supabase.auth
          .signUp(email: email, password: password, data: {'name': name});
      return Right(authResponse.user!.id);
    } catch (e) {
      if (e is AuthException) {
        return Left(AppException.fromServerException(e.message));
      } else {
        return const Left(AppException());
      }
    }
  }

  @override
  Future<Either<AppException, String>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    throw UnimplementedError();
  }
}
