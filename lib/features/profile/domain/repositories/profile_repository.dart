import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:dartz/dartz.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, List<Blog>>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });
}
