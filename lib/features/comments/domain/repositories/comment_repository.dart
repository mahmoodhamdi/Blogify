import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:dartz/dartz.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, List<Comment>>> getComments({
    required String blogId,
    int page = 0,
    int limit = 20,
  });

  Future<Either<Failure, Comment>> addComment({
    required String blogId,
    required String userId,
    required String content,
    String? parentId,
  });

  Future<Either<Failure, Comment>> updateComment({
    required String commentId,
    required String content,
  });

  Future<Either<Failure, void>> deleteComment({
    required String commentId,
  });
}
