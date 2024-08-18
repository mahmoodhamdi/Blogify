import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/domain/entities/blog_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class BlogRepository {
  Future<Either<AppException, BlogEntity>> addBlog({
    File? image,
    required String title,
    required String content,
    // required DateTime updatedAt,
    required String posterId,
    List<String>? topics,
  });
}
