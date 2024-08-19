import 'package:blogify/core/common/usecase/usecase.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/domain/entities/blog_entity.dart';
import 'package:blogify/features/blog/domain/repository/blog_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBlogsUsecase implements Usecase<List<BlogEntity>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlogsUsecase({required this.blogRepository});

  @override
  Future<Either<AppException, List<BlogEntity>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
