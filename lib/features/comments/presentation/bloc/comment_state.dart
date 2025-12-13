part of 'comment_bloc.dart';

@immutable
sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

final class CommentInitial extends CommentState {
  const CommentInitial();
}

final class CommentLoading extends CommentState {
  const CommentLoading();
}

final class CommentFailure extends CommentState {
  final String error;
  const CommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final String blogId;
  final bool hasReachedMax;
  final int currentPage;

  const CommentLoaded({
    required this.comments,
    required this.blogId,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  CommentLoaded copyWith({
    List<Comment>? comments,
    String? blogId,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return CommentLoaded(
      comments: comments ?? this.comments,
      blogId: blogId ?? this.blogId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [comments, blogId, hasReachedMax, currentPage];
}

final class CommentAdded extends CommentState {
  final Comment comment;
  const CommentAdded(this.comment);

  @override
  List<Object?> get props => [comment];
}

final class CommentUpdated extends CommentState {
  final Comment comment;
  const CommentUpdated(this.comment);

  @override
  List<Object?> get props => [comment];
}

final class CommentDeleted extends CommentState {
  const CommentDeleted();
}
