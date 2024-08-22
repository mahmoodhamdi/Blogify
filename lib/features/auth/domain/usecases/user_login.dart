import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
 
class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
