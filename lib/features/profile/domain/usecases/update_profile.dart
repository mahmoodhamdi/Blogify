import 'dart:io';

import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final ProfileRepository profileRepository;
  const UpdateProfile(this.profileRepository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await profileRepository.updateProfile(
      userId: params.userId,
      name: params.name,
      avatarImage: params.avatarImage,
    );
  }
}

class UpdateProfileParams {
  final String userId;
  final String name;
  final File? avatarImage;

  const UpdateProfileParams({
    required this.userId,
    required this.name,
    this.avatarImage,
  });
}
