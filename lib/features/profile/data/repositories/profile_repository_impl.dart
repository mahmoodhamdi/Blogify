import 'dart:io';

import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/network/connection_checker.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:blogify/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ConnectionChecker connectionChecker;

  const ProfileRepositoryImpl(
    this.profileRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Blog>>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final blogs = await profileRemoteDataSource.getUserBlogs(
        userId: userId,
        page: page,
        limit: limit,
      );
      return right(blogs);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    required String name,
    File? avatarImage,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final user = await profileRemoteDataSource.updateProfile(
        userId: userId,
        name: name,
        avatarImage: avatarImage,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
