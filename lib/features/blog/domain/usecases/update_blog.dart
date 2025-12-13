import 'dart:io';

import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateBlog implements UseCase<Blog, UpdateBlogParams> {
  final BlogRepository blogRepository;
  const UpdateBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UpdateBlogParams params) async {
    return await blogRepository.updateBlog(
      blogId: params.blogId,
      title: params.title,
      content: params.content,
      topics: params.topics,
      image: params.image,
    );
  }
}

class UpdateBlogParams {
  final String blogId;
  final String title;
  final String content;
  final List<String> topics;
  final File? image; // Optional - only if user wants to change the image

  const UpdateBlogParams({
    required this.blogId,
    required this.title,
    required this.content,
    required this.topics,
    this.image,
  });
}
