import 'dart:io';
import 'package:blogify/core/constants/constants.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/network/connection_checker.dart';
import 'package:blogify/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';
 import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs(
        page: page,
        limit: limit,
      );
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog({required String blogId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      await blogRemoteDataSource.deleteBlog(blogId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    File? image,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      String imageUrl = '';

      // If a new image is provided, update it
      if (image != null) {
        imageUrl = await blogRemoteDataSource.updateBlogImage(
          image: image,
          blogId: blogId,
        );
      }

      // Create the blog model with updated fields
      final blogModel = BlogModel(
        id: blogId,
        posterId: '', // Will not be updated (excluded in toUpdateJson)
        title: title,
        content: content,
        imageUrl: imageUrl, // Empty string = don't update image
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final updatedBlog = await blogRemoteDataSource.updateBlog(blogModel);

      return right(updatedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
