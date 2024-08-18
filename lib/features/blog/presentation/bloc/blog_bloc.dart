import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/domain/entities/blog_entity.dart';
import 'package:blogify/features/blog/domain/usecases/add_blog_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final AddBlogUsecase addBlogUsecase;
  BlogBloc({required this.addBlogUsecase}) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) async {
      emit(BlogLoading());
    });

    on<BlogUpload>(_onBlogUpload);
  }

  Future<void> _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await addBlogUsecase.call(AddBlogParams(
        image: event.image,
        title: event.title,
        content: event.content,
        // updatedAt: event.updatedAt,
        posterId: event.posterId,
        topics: event.topics));
    result.fold(
      (failure) => emit(BlogFailure(failure: failure)),
      (blog) => emit(BlogLoaded(blog: blog)),
    );
  }
}
