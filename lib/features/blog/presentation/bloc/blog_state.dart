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
