import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class AddComment implements UseCase<Comment, AddCommentParams> {
  final CommentRepository commentRepository;
  const AddComment(this.commentRepository);

  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) async {
    return await commentRepository.addComment(
      blogId: params.blogId,
      userId: params.userId,
      content: params.content,
      parentId: params.parentId,
    );
  }
}

class AddCommentParams {
  final String blogId;
  final String userId;
  final String content;
  final String? parentId;

  const AddCommentParams({
    required this.blogId,
    required this.userId,
    required this.content,
    this.parentId,
  });
}
