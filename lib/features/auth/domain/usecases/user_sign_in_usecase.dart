import 'package:blogify/core/common/usecase/usecase.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/domain/entities/user_entity.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UserSignInUseCase implements Usecase<UserEntity, UserSignInParams> {
  final AuthRepository authRepository;
  UserSignInUseCase({required this.authRepository});
  @override
  Future<Either<AppException, UserEntity>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
