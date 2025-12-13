import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams> {
  final BlogRepository blogRepository;
  const DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(blogId: params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  const DeleteBlogParams({required this.blogId});
}
