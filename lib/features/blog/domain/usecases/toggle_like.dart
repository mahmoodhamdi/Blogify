import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleLike implements UseCase<Blog, ToggleLikeParams> {
  final BlogRepository blogRepository;
  const ToggleLike(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(ToggleLikeParams params) async {
    return await blogRepository.toggleLike(
      blogId: params.blogId,
      userId: params.userId,
    );
  }
}

class ToggleLikeParams {
  final String blogId;
  final String userId;

  const ToggleLikeParams({
    required this.blogId,
    required this.userId,
  });
}
