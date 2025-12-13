import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class SearchBlogs implements UseCase<List<Blog>, SearchBlogsParams> {
  final BlogRepository blogRepository;
  const SearchBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(SearchBlogsParams params) async {
    return await blogRepository.searchBlogs(
      query: params.query,
      topics: params.topics,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchBlogsParams {
  final String query;
  final List<String>? topics;
  final int page;
  final int limit;

  const SearchBlogsParams({
    required this.query,
    this.topics,
    this.page = 0,
    this.limit = 10,
  });
}
