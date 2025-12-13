import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class GetBookmarkedBlogs implements UseCase<List<Blog>, GetBookmarkedBlogsParams> {
  final BlogRepository blogRepository;
  const GetBookmarkedBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(GetBookmarkedBlogsParams params) async {
    return await blogRepository.getBookmarkedBlogs(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetBookmarkedBlogsParams {
  final String userId;
  final int page;
  final int limit;

  const GetBookmarkedBlogsParams({
    required this.userId,
    this.page = 0,
    this.limit = 10,
  });
}
