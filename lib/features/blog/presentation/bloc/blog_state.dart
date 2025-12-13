part of 'blog_bloc.dart';

@immutable
sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

final class BlogInitial extends BlogState {
  const BlogInitial();
}

final class BlogLoading extends BlogState {
  const BlogLoading();
}

final class BlogFailure extends BlogState {
  final String error;
  const BlogFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class BlogUploadSuccess extends BlogState {
  const BlogUploadSuccess();
}

final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  final bool hasReachedMax;
  final int currentPage;

  const BlogsDisplaySuccess(
    this.blogs, {
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  BlogsDisplaySuccess copyWith({
    List<Blog>? blogs,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return BlogsDisplaySuccess(
      blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [blogs, hasReachedMax, currentPage];
}

final class BlogDeleteSuccess extends BlogState {
  const BlogDeleteSuccess();
}

final class BlogUpdateSuccess extends BlogState {
  const BlogUpdateSuccess();
}

final class BlogSearchSuccess extends BlogState {
  final List<Blog> blogs;
  final String query;
  final List<String>? topics;
  final bool hasReachedMax;
  final int currentPage;

  const BlogSearchSuccess({
    required this.blogs,
    required this.query,
    this.topics,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  BlogSearchSuccess copyWith({
    List<Blog>? blogs,
    String? query,
    List<String>? topics,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return BlogSearchSuccess(
      blogs: blogs ?? this.blogs,
      query: query ?? this.query,
      topics: topics ?? this.topics,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [blogs, query, topics, hasReachedMax, currentPage];
}

final class BlogLikeToggled extends BlogState {
  final Blog blog;
  const BlogLikeToggled(this.blog);

  @override
  List<Object?> get props => [blog];
}

final class BlogBookmarkToggled extends BlogState {
  final Blog blog;
  const BlogBookmarkToggled(this.blog);

  @override
  List<Object?> get props => [blog];
}

final class BlogBookmarksDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  final bool hasReachedMax;
  final int currentPage;

  const BlogBookmarksDisplaySuccess(
    this.blogs, {
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  BlogBookmarksDisplaySuccess copyWith({
    List<Blog>? blogs,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return BlogBookmarksDisplaySuccess(
      blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [blogs, hasReachedMax, currentPage];
}
