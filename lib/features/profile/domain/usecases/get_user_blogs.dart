import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserBlogs implements UseCase<List<Blog>, GetUserBlogsParams> {
  final ProfileRepository profileRepository;
  const GetUserBlogs(this.profileRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(GetUserBlogsParams params) async {
    return await profileRepository.getUserBlogs(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetUserBlogsParams {
  final String userId;
  final int page;
  final int limit;

  const GetUserBlogsParams({
    required this.userId,
    this.page = 0,
    this.limit = 10,
  });
}
