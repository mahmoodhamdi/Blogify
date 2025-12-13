import 'dart:io';

import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/profile/domain/usecases/get_user_blogs.dart';
import 'package:blogify/features/profile/domain/usecases/update_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserBlogs _getUserBlogs;
  final UpdateProfile _updateProfile;

  ProfileBloc({
    required GetUserBlogs getUserBlogs,
    required UpdateProfile updateProfile,
  })  : _getUserBlogs = getUserBlogs,
        _updateProfile = updateProfile,
        super(const ProfileInitial()) {
    on<ProfileFetchUserBlogs>(_onFetchUserBlogs);
    on<ProfileFetchMoreBlogs>(_onFetchMoreBlogs);
    on<ProfileUpdateRequested>(_onUpdateProfile);
  }

  static const int _blogsPerPage = 10;

  void _onFetchUserBlogs(
    ProfileFetchUserBlogs event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final res = await _getUserBlogs(
      GetUserBlogsParams(
        userId: event.userId,
        page: 0,
        limit: _blogsPerPage,
      ),
    );

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (blogs) => emit(ProfileLoaded(
        blogs: blogs,
        userId: event.userId,
        hasReachedMax: blogs.length < _blogsPerPage,
        currentPage: 0,
      )),
    );
  }

  void _onFetchMoreBlogs(
    ProfileFetchMoreBlogs event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;

      final res = await _getUserBlogs(
        GetUserBlogsParams(
          userId: currentState.userId,
          page: nextPage,
          limit: _blogsPerPage,
        ),
      );

      res.fold(
        (l) => emit(ProfileFailure(l.message)),
        (newBlogs) {
          if (newBlogs.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(ProfileLoaded(
              blogs: [...currentState.blogs, ...newBlogs],
              userId: currentState.userId,
              hasReachedMax: newBlogs.length < _blogsPerPage,
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  void _onUpdateProfile(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdating());

    final res = await _updateProfile(
      UpdateProfileParams(
        userId: event.userId,
        name: event.name,
        avatarImage: event.avatarImage,
      ),
    );

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (user) => emit(ProfileUpdateSuccess(user)),
    );
  }
}
