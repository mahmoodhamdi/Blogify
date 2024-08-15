import 'package:blogify/core/common/usecase/usecase.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/domain/entities/user_entity.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUserUsecase implements Usecase<UserEntity?, NoParams> {
  final AuthRepository authRepository;

  GetCurrentUserUsecase({required this.authRepository});

  @override
  Future<Either<AppException, UserEntity?>> call(NoParams params) async {
    return await authRepository.getCurrentUserData();
  }
}
