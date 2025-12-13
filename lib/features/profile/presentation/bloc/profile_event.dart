part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileFetchUserBlogs extends ProfileEvent {
  final String userId;

  ProfileFetchUserBlogs({required this.userId});
}

final class ProfileFetchMoreBlogs extends ProfileEvent {}
