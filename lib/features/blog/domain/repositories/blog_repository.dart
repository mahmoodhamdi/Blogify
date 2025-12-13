import 'dart:io';

import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:dartz/dartz.dart';
 
abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs({
    int page = 0,
    int limit = 10,
  });

  Future<Either<Failure, void>> deleteBlog({required String blogId});

  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    File? image,
  });

  Future<Either<Failure, List<Blog>>> searchBlogs({
    required String query,
    List<String>? topics,
    int page = 0,
    int limit = 10,
  });

  Future<Either<Failure, Blog>> toggleLike({
    required String blogId,
    required String userId,
  });

  Future<Either<Failure, Blog>> toggleBookmark({
    required String blogId,
    required String userId,
  });

  Future<Either<Failure, List<Blog>>> getBookmarkedBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });

  Future<Either<Failure, bool>> isLiked({
    required String blogId,
    required String userId,
  });

  Future<Either<Failure, bool>> isBookmarked({
    required String blogId,
    required String userId,
  });
}
