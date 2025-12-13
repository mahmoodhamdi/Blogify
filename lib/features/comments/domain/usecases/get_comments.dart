import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetComments implements UseCase<List<Comment>, GetCommentsParams> {
  final CommentRepository commentRepository;
  const GetComments(this.commentRepository);

  @override
  Future<Either<Failure, List<Comment>>> call(GetCommentsParams params) async {
    return await commentRepository.getComments(
      blogId: params.blogId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCommentsParams {
  final String blogId;
  final int page;
  final int limit;

  const GetCommentsParams({
    required this.blogId,
    this.page = 0,
    this.limit = 20,
  });
}
