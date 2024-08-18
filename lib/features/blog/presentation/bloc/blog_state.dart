part of 'blog_bloc.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogsListLoaded extends BlogState {
  final List<BlogEntity> blogList;

  const BlogsListLoaded({required this.blogList});

  @override
  List<Object> get props => [blogList];
}

class BlogAdded extends BlogState {
  final BlogEntity blog;

  const BlogAdded({required this.blog});

  @override
  List<Object> get props => [blog];
}

class BlogLoaded extends BlogState {
  final BlogEntity blog;

  const BlogLoaded({required this.blog});

  @override
  List<Object> get props => [blog];
}

class BlogFailure extends BlogState {
  final AppException failure;

  const BlogFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
