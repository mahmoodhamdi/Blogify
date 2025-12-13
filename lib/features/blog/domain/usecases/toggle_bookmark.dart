import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleBookmark implements UseCase<Blog, ToggleBookmarkParams> {
  final BlogRepository blogRepository;
  const ToggleBookmark(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(ToggleBookmarkParams params) async {
    return await blogRepository.toggleBookmark(
      blogId: params.blogId,
      userId: params.userId,
    );
  }
}

class ToggleBookmarkParams {
  final String blogId;
  final String userId;

  const ToggleBookmarkParams({
    required this.blogId,
    required this.userId,
  });
}
