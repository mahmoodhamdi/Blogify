import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/network/connection_checker.dart';
import 'package:blogify/features/comments/data/datasources/comment_remote_data_source.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource commentRemoteDataSource;
  final ConnectionChecker connectionChecker;

  CommentRepositoryImpl(
    this.commentRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Comment>>> getComments({
    required String blogId,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final comments = await commentRemoteDataSource.getComments(
        blogId: blogId,
        page: page,
        limit: limit,
      );
      return right(comments);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment({
    required String blogId,
    required String userId,
    required String content,
    String? parentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final comment = await commentRemoteDataSource.addComment(
        blogId: blogId,
        userId: userId,
        content: content,
        parentId: parentId,
      );
      return right(comment);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Comment>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final comment = await commentRemoteDataSource.updateComment(
        commentId: commentId,
        content: content,
      );
      return right(comment);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      await commentRemoteDataSource.deleteComment(commentId: commentId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
