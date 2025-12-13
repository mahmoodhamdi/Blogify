import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/usecases/add_comment.dart';
import 'package:blogify/features/comments/domain/usecases/delete_comment.dart';
import 'package:blogify/features/comments/domain/usecases/get_comments.dart';
import 'package:blogify/features/comments/domain/usecases/update_comment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments _getComments;
  final AddComment _addComment;
  final UpdateComment _updateComment;
  final DeleteComment _deleteComment;

  CommentBloc({
    required GetComments getComments,
    required AddComment addComment,
    required UpdateComment updateComment,
    required DeleteComment deleteComment,
  })  : _getComments = getComments,
        _addComment = addComment,
        _updateComment = updateComment,
        _deleteComment = deleteComment,
        super(const CommentInitial()) {
    on<CommentFetch>(_onFetch);
    on<CommentFetchMore>(_onFetchMore);
    on<CommentAdd>(_onAdd);
    on<CommentUpdate>(_onUpdate);
    on<CommentDelete>(_onDelete);
  }

  static const int _commentsPerPage = 20;

  void _onFetch(
    CommentFetch event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CommentLoading());

    final res = await _getComments(
      GetCommentsParams(
        blogId: event.blogId,
        page: 0,
        limit: _commentsPerPage,
      ),
    );

    res.fold(
      (l) => emit(CommentFailure(l.message)),
      (comments) => emit(CommentLoaded(
        comments: comments,
        blogId: event.blogId,
        hasReachedMax: comments.length < _commentsPerPage,
        currentPage: 0,
      )),
    );
  }

  void _onFetchMore(
    CommentFetchMore event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is CommentLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;

      final res = await _getComments(
        GetCommentsParams(
          blogId: currentState.blogId,
          page: nextPage,
          limit: _commentsPerPage,
        ),
      );

      res.fold(
        (l) => emit(CommentFailure(l.message)),
        (newComments) {
          if (newComments.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(CommentLoaded(
              comments: [...currentState.comments, ...newComments],
              blogId: currentState.blogId,
              hasReachedMax: newComments.length < _commentsPerPage,
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  void _onAdd(
    CommentAdd event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;

    final res = await _addComment(
      AddCommentParams(
        blogId: event.blogId,
        userId: event.userId,
        content: event.content,
        parentId: event.parentId,
      ),
    );

    res.fold(
      (l) => emit(CommentFailure(l.message)),
      (comment) {
        emit(CommentAdded(comment));
        // Refresh comments to show the new comment
        if (currentState is CommentLoaded) {
          add(CommentFetch(blogId: currentState.blogId));
        }
      },
    );
  }

  void _onUpdate(
    CommentUpdate event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;

    final res = await _updateComment(
      UpdateCommentParams(
        commentId: event.commentId,
        content: event.content,
      ),
    );

    res.fold(
      (l) => emit(CommentFailure(l.message)),
      (comment) {
        emit(CommentUpdated(comment));
        // Refresh comments to show the updated comment
        if (currentState is CommentLoaded) {
          add(CommentFetch(blogId: currentState.blogId));
        }
      },
    );
  }

  void _onDelete(
    CommentDelete event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;

    final res = await _deleteComment(
      DeleteCommentParams(commentId: event.commentId),
    );

    res.fold(
      (l) => emit(CommentFailure(l.message)),
      (_) {
        emit(const CommentDeleted());
        // Refresh comments to reflect deletion
        if (currentState is CommentLoaded) {
          add(CommentFetch(blogId: currentState.blogId));
        }
      },
    );
  }
}
