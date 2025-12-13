import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteComment implements UseCase<void, DeleteCommentParams> {
  final CommentRepository commentRepository;
  const DeleteComment(this.commentRepository);

  @override
  Future<Either<Failure, void>> call(DeleteCommentParams params) async {
    return await commentRepository.deleteComment(
      commentId: params.commentId,
    );
  }
}

class DeleteCommentParams {
  final String commentId;

  const DeleteCommentParams({
    required this.commentId,
  });
}
