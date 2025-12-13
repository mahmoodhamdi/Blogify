import 'dart:io';

import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:dartz/dartz.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, List<Blog>>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });

  Future<Either<Failure, User>> updateProfile({
    required String userId,
    required String name,
    File? avatarImage,
  });
}
