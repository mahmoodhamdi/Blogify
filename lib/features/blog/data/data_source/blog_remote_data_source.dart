import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<Either<AppException, BlogModel>> addBlog(
      {required BlogModel blogModel});

  Future<Either<AppException, String>> uploadBlogImage(
      {File? image, required BlogModel blogModel});

  Future<Either<AppException, BlogModel>> getBlogById({required String id});

  Future<Either<AppException, List<BlogModel>>> getAllBlogs();

  Future<Either<AppException, BlogModel>> updateBlog(
      {required BlogModel blogModel});

  Future<Either<AppException, BlogModel>> deleteBlog({required String id});

  Future<Either<AppException, List<BlogModel>>> getBlogsByTopic(
      {required String topic});

  Future<Either<AppException, List<BlogModel>>> getBlogsByPosterId(
      String posterId);

  Future<Either<AppException, List<BlogModel>>> getBlogsByTitle(
      {required String title});

  Future<Either<AppException, List<BlogModel>>> getBlogsByContent(
      {required String content});

  Future<Either<AppException, List<BlogModel>>> getBlogsByDateTime(
      {required String dateTime});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<Either<AppException, BlogModel>> addBlog(
      {required BlogModel blogModel}) async {
    try {
      // First, insert the blog data
      await supabaseClient.from('blogs').insert(blogModel.toMap());

      // Then, fetch the inserted data
      final response = await supabaseClient
          .from('blogs')
          .select()
          .eq('id', blogModel.id)
          .single();

      return Right(BlogModel.fromMap(response));
    } catch (e) {
      print("Error adding blog: $e");
      return Left(AppException.fromServerException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, String>> uploadBlogImage(
      {File? image, required BlogModel blogModel}) async {
    try {
      if (image == null) {
        return const Left(AppException());
      }
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

  @override
  Future<Either<AppException, BlogModel>> deleteBlog({required String id}) {
    // TODO: implement deleteBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, BlogModel>> getBlogById({required String id}) {
    // TODO: implement getBlogById
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByContent(
      {required String content}) {
    // TODO: implement getBlogsByContent
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByDateTime(
      {required String dateTime}) {
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
  Future<Either<AppException, List<BlogModel>>> getBlogsByTitle(
      {required String title}) {
    // TODO: implement getBlogsByTitle
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getBlogsByTopic(
      {required String topic}) {
    // TODO: implement getBlogsByTopic
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, BlogModel>> updateBlog(
      {required BlogModel blogModel}) {
    // TODO: implement updateBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<BlogModel>>> getAllBlogs() async {
    try {
      final response =
          await supabaseClient.from('blogs').select("*,profiles(name)");
      List<BlogModel> blogs = response
          .map((e) => BlogModel.fromMap(e)
              .copyWithPosterName(posterName: e['profiles']['name']))
          .toList();
      return Right(blogs);
    } catch (e) {
      return Left(AppException.fromServerException(e.toString()));
    }
  }
}
