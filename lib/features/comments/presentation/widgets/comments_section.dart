import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/presentation/bloc/comment_bloc.dart';
import 'package:blogify/features/comments/presentation/widgets/comment_card.dart';
import 'package:blogify/features/comments/presentation/widgets/comment_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsSection extends StatefulWidget {
  final String blogId;

  const CommentsSection({
    super.key,
    required this.blogId,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  String? _replyToCommentId;
  String? _replyToName;
  String? _editingCommentId;
  String? _editingContent;

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(CommentFetch(blogId: widget.blogId));
  }

  String? _getCurrentUserId() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      return appUserState.user.id;
    }
    return null;
  }

  void _handleReply(Comment comment) {
    setState(() {
      _replyToCommentId = comment.id;
      _replyToName = comment.userName ?? 'Anonymous';
      _editingCommentId = null;
      _editingContent = null;
    });
  }

  void _handleEdit(Comment comment) {
    setState(() {
      _editingCommentId = comment.id;
      _editingContent = comment.content;
      _replyToCommentId = null;
      _replyToName = null;
    });
  }

  void _handleDelete(Comment comment) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text(
          'Are you sure you want to delete this comment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CommentBloc>().add(
                    CommentDelete(commentId: comment.id),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppPalette.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _cancelReplyOrEdit() {
    setState(() {
      _replyToCommentId = null;
      _replyToName = null;
      _editingCommentId = null;
      _editingContent = null;
    });
  }

  void _handleSubmit(String content) {
    final userId = _getCurrentUserId();
    if (userId == null) {
      showSnackBar(
        content: 'Please log in to comment',
        context: context,
        type: SnackBarType.error,
      );
      return;
    }

    if (_editingCommentId != null) {
      context.read<CommentBloc>().add(
            CommentUpdate(
              commentId: _editingCommentId!,
              content: content,
            ),
          );
    } else {
      context.read<CommentBloc>().add(
            CommentAdd(
              blogId: widget.blogId,
              userId: userId,
              content: content,
              parentId: _replyToCommentId,
            ),
          );
    }

    _cancelReplyOrEdit();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppPalette.darkText : AppPalette.lightText;
    final currentUserId = _getCurrentUserId();

    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentFailure) {
          showSnackBar(
            content: state.error,
            context: context,
            type: SnackBarType.error,
          );
        } else if (state is CommentAdded) {
          showSnackBar(
            content: 'Comment added',
            context: context,
            type: SnackBarType.success,
          );
        } else if (state is CommentUpdated) {
          showSnackBar(
            content: 'Comment updated',
            context: context,
            type: SnackBarType.success,
          );
        } else if (state is CommentDeleted) {
          showSnackBar(
            content: 'Comment deleted',
            context: context,
            type: SnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.comment,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (state is CommentLoaded) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppPalette.darkPrimary.withValues(alpha: 0.2)
                            : AppPalette.lightPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${state.comments.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppPalette.darkPrimary
                              : AppPalette.lightPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Comments list
            if (state is CommentLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Loader(),
                ),
              )
            else if (state is CommentLoaded)
              state.comments.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Be the first to comment!',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return CommentCard(
                          comment: comment,
                          currentUserId: currentUserId,
                          onReply: () => _handleReply(comment),
                          onEdit: () => _handleEdit(comment),
                          onDelete: () => _handleDelete(comment),
                        );
                      },
                    ),

            // Comment input
            if (currentUserId != null)
              CommentInput(
                replyToName: _replyToName,
                initialContent: _editingContent,
                isEditing: _editingCommentId != null,
                onSubmit: _handleSubmit,
                onCancel: (_replyToCommentId != null || _editingCommentId != null)
                    ? _cancelReplyOrEdit
                    : null,
              ),
          ],
        );
      },
    );
  }
}
