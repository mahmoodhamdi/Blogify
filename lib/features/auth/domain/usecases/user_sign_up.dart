import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
 
class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
