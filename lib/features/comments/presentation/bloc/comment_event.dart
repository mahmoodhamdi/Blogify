part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

final class CommentFetch extends CommentEvent {
  final String blogId;

  CommentFetch({required this.blogId});
}

final class CommentFetchMore extends CommentEvent {}

final class CommentAdd extends CommentEvent {
  final String blogId;
  final String userId;
  final String content;
  final String? parentId;

  CommentAdd({
    required this.blogId,
    required this.userId,
    required this.content,
    this.parentId,
  });
}

final class CommentUpdate extends CommentEvent {
  final String commentId;
  final String content;

  CommentUpdate({
    required this.commentId,
    required this.content,
  });
}

final class CommentDelete extends CommentEvent {
  final String commentId;

  CommentDelete({required this.commentId});
}
