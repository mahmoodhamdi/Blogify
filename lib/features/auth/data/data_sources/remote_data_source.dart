import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Session? get currentUserSession;
  Future<Either<AppException, UserModel>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<Either<AppException, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AppException, UserModel?>> getCurrentUserData();
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

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  @override
  Future<Either<AppException, UserModel?>> getCurrentUserData() async {
    try {
      print("Getting current user data");
      print("Current user: ${supabaseClient.auth.currentUser}");
      if (supabaseClient.auth.currentUser != null) {
        final response = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', supabaseClient.auth.currentUser!.id);
        print("Successfully got current user data");
        return Right(UserModel.fromJson(response.first).copyWith(
          id: supabaseClient.auth.currentUser!.id,
          email: supabaseClient.auth.currentUser!.email,
        ));
      }

      print("No current user found");
      return const Right(null);
    } catch (e) {
      print("Error getting current user data: $e");
      if (e is AuthException) {
        return Left(AppException.fromServerException(e.message));
      } else {
        return const Left(AppException());
      }
    }
  }
}
