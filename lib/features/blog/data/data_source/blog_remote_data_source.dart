import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<Either<AppException, BlogModel>> addBlog(BlogModel blogModel);

  Future<Either<AppException, String>> uploadBlogImage(
      {required File image, required BlogModel blogModel});

  Future<Either<AppException, BlogModel>> getBlogById(String id);

  Future<Either<AppException, List<BlogModel>>> getAllBlogs();

  Future<Either<AppException, BlogModel>> updateBlog(BlogModel blogModel);

  Future<Either<AppException, BlogModel>> deleteBlog(String id);

  Future<Either<AppException, List<BlogModel>>> getBlogsByTopic(String topic);

  Future<Either<AppException, List<BlogModel>>> getBlogsByPosterId(
      String posterId);

  Future<Either<AppException, List<BlogModel>>> getBlogsByTitle(String title);

  Future<Either<AppException, List<BlogModel>>> getBlogsByContent(
      String content);

  Future<Either<AppException, List<BlogModel>>> getBlogsByDateTime(
      String dateTime);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<Either<AppException, BlogModel>> addBlog(BlogModel blogModel) async {
    try {
      final response =
          await supabaseClient.from('blogs').insert(blogModel.toMap()).select();
      return Right(BlogModel.fromMap(response.first));
    } catch (e) {
      return const Left(AppException());
    }
  }

  @override
  Future<Either<AppException, BlogModel>> deleteBlog(String id) {
    // TODO: implement deleteBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getAllBlogs() {
    // TODO: implement getAllBlogs
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, BlogModel>> getBlogById(String id) {
    // TODO: implement getBlogById
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByContent(
      String content) {
    // TODO: implement getBlogsByContent
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByDateTime(
      String dateTime) {
    // TODO: implement getBlogsByDateTime
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByPosterId(
      String posterId) {
    // TODO: implement getBlogsByPosterId
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByTitle(String title) {
    // TODO: implement getBlogsByTitle
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByTopic(String topic) {
    // TODO: implement getBlogsByTopic
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, BlogModel>> updateBlog(BlogModel blogModel) {
    // TODO: implement updateBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, String>> uploadBlogImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(blogModel.id, image);
      return Right(supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id)
          .toString());
    } catch (e) {
      return Left(AppException.fromServerException(e.toString()));
    }
  }
}
