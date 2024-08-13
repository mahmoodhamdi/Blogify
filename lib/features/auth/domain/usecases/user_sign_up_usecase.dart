  import 'package:blogify/core/common/usecase/usecase.dart';
  import 'package:blogify/core/error/exceptions.dart';
  import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
  import 'package:dartz/dartz.dart';

  class UserSignUpUseCase implements Usecase<String, UserSignUpParams> {
    final AuthRepository authRepository;
    UserSignUpUseCase({required this.authRepository});
    @override
    Future<Either<AppException, String>> call(UserSignUpParams params) async {
      return await authRepository.signUpWithEmailAndPassword(
          name: params.name, email: params.email, password: params.password);
    }
  }

  class UserSignUpParams {
    final String name;
    final String email;
    final String password;

    UserSignUpParams(
        {required this.name, required this.email, required this.password});
  }
