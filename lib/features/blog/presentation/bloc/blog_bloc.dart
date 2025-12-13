import 'dart:io';

import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/usecases/delete_blog.dart';
import 'package:blogify/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogify/features/blog/domain/usecases/update_blog.dart';
import 'package:blogify/features/blog/domain/usecases/upload_blog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final UpdateBlog _updateBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
    required UpdateBlog updateBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _deleteBlog = deleteBlog,
        _updateBlog = updateBlog,
        super(const BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogFetchMoreBlogs>(_onFetchMoreBlogs);
    on<BlogDelete>(_onBlogDelete);
    on<BlogUpdate>(_onBlogUpdate);
  }

  static const int _blogsPerPage = 10;

  void _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(const BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    emit(const BlogLoading());

    final res = await _getAllBlogs(
      const GetAllBlogsParams(page: 0, limit: _blogsPerPage),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogsDisplaySuccess(
        blogs,
        hasReachedMax: blogs.length < _blogsPerPage,
        currentPage: 0,
      )),
    );
  }

  void _onFetchMoreBlogs(
    BlogFetchMoreBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final currentState = state;
    if (currentState is BlogsDisplaySuccess && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;

      final res = await _getAllBlogs(
        GetAllBlogsParams(page: nextPage, limit: _blogsPerPage),
      );

      res.fold(
        (l) => emit(BlogFailure(l.message)),
        (newBlogs) {
          if (newBlogs.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(BlogsDisplaySuccess(
              [...currentState.blogs, ...newBlogs],
              hasReachedMax: newBlogs.length < _blogsPerPage,
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  void _onBlogDelete(
    BlogDelete event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (_) => emit(const BlogDeleteSuccess()),
    );
  }

  void _onBlogUpdate(
    BlogUpdate event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _updateBlog(
      UpdateBlogParams(
        blogId: event.blogId,
        title: event.title,
        content: event.content,
        topics: event.topics,
        image: event.image,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (_) => emit(const BlogUpdateSuccess()),
    );
  }
}
