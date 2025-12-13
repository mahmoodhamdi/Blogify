import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateComment implements UseCase<Comment, UpdateCommentParams> {
  final CommentRepository commentRepository;
  const UpdateComment(this.commentRepository);

  @override
  Future<Either<Failure, Comment>> call(UpdateCommentParams params) async {
    return await commentRepository.updateComment(
      commentId: params.commentId,
      content: params.content,
    );
  }
}

class UpdateCommentParams {
  final String commentId;
  final String content;

  const UpdateCommentParams({
    required this.commentId,
    required this.content,
  });
}
