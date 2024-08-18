import 'dart:io';

import 'package:blogify/core/common/usecase/usecase.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/domain/entities/blog_entity.dart';
import 'package:blogify/features/blog/domain/repository/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AddBlogUsecase implements Usecase<BlogEntity, AddBlogParams> {
  final BlogRepository blogRepository;

  AddBlogUsecase({
    required this.blogRepository,
  });

  @override
  Future<Either<AppException, BlogEntity>> call(AddBlogParams params) async {
    return await blogRepository.addBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      // updatedAt: params.updatedAt,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class AddBlogParams extends Equatable {
  final File? image;
  final String title;
  final String content;
  // final DateTime updatedAt;
  final String posterId;
  final List<String>? topics;

  const AddBlogParams({
    this.image,
    required this.title,
    required this.content,
    // required this.updatedAt,
    required this.posterId,
    this.topics,
  });

  @override
  List<Object?> get props =>
      [image, title, content, posterId, topics];
}
