import 'dart:io';

import 'package:blogify/core/usecase/usecase.dart';
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
    on<BlogEvent>((event, emit) => emit(const BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogDelete>(_onBlogDelete);
    on<BlogUpdate>(_onBlogUpdate);
  }

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
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
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
