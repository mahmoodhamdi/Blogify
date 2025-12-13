part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileFetchUserBlogs extends ProfileEvent {
  final String userId;

  ProfileFetchUserBlogs({required this.userId});
}

final class ProfileFetchMoreBlogs extends ProfileEvent {}

final class ProfileUpdateRequested extends ProfileEvent {
  final String userId;
  final String name;
  final File? avatarImage;

  ProfileUpdateRequested({
    required this.userId,
    required this.name,
    this.avatarImage,
  });
}
