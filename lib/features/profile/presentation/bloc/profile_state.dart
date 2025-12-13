part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final List<Blog> blogs;
  final String userId;
  final bool hasReachedMax;
  final int currentPage;

  const ProfileLoaded({
    required this.blogs,
    required this.userId,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  ProfileLoaded copyWith({
    List<Blog>? blogs,
    String? userId,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProfileLoaded(
      blogs: blogs ?? this.blogs,
      userId: userId ?? this.userId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [blogs, userId, hasReachedMax, currentPage];
}

final class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}
