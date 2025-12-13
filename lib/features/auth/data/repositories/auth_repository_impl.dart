import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/network/connection_checker.dart';
import 'package:blogify/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/features/auth/data/models/user_model.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(const AuthFailure(message: 'User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(const AuthFailure(message: 'User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(const NetworkFailure());
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      // Check for auth-specific errors
      final message = e.message.toLowerCase();
      if (message.contains('invalid') ||
          message.contains('password') ||
          message.contains('email') ||
          message.contains('credentials')) {
        return left(AuthFailure(message: e.message));
      }
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
