import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:blogify/features/blog/domain/entities/blog_entity.dart';
import 'package:blogify/features/blog/domain/repository/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl({required this.blogRemoteDataSource});
  @override
  Future<Either<AppException, BlogEntity>> addBlog({
    File? image,
    required String title,
    required String content,
    // required DateTime updatedAt,
    required String posterId,
    List<String>? topics,
  }) async {
    BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        title: title,
        posterId: posterId,
        content: content,
        // updatedAt: updatedAt,
        topics: topics);

    final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image, blogModel: blogModel);
    imageUrl.fold((l) => const AppException(),
        (r) => blogModel = blogModel.copyWithImageUrl(imageUrl: r));
    await blogRemoteDataSource.addBlog(blogModel: blogModel);

    return Right(blogModel);
  }

  @override
  Future<Either<AppException, List<BlogEntity>>> getAllBlogs() async {
    return await blogRemoteDataSource.getAllBlogs();
  }
}
