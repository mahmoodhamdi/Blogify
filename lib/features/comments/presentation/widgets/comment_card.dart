import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/format_date.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final String? currentUserId;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isReply;

  const CommentCard({
    super.key,
    required this.comment,
    this.currentUserId,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.isReply = false,
  });

  bool get isOwner => currentUserId == comment.userId;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppPalette.darkText : AppPalette.lightText;
    final surfaceColor =
        isDarkMode ? AppPalette.darkSurface : AppPalette.lightSurface;

    return Container(
      margin: EdgeInsets.only(
        left: isReply ? 40 : 0,
        bottom: 12,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: isReply
            ? Border(
                left: BorderSide(
                  color: isDarkMode
                      ? AppPalette.darkPrimary
                      : AppPalette.lightPrimary,
                  width: 2,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isDarkMode
                    ? AppPalette.darkPrimary
                    : AppPalette.lightPrimary,
                backgroundImage: comment.userAvatarUrl != null
                    ? CachedNetworkImageProvider(comment.userAvatarUrl!)
                    : null,
                child: comment.userAvatarUrl == null
                    ? Text(
                        (comment.userName ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          color: isDarkMode
                              ? AppPalette.darkBackground
                              : AppPalette.lightBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName ?? 'Anonymous',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      formatDateBydMMMYYYY(comment.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: textColor.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment content
          Text(
            comment.content,
            style: TextStyle(
              color: textColor,
              height: 1.4,
            ),
          ),

          // Reply button (only for top-level comments)
          if (!isReply && onReply != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onReply,
              icon: Icon(
                Icons.reply,
                size: 16,
                color: isDarkMode
                    ? AppPalette.darkPrimary
                    : AppPalette.lightPrimary,
              ),
              label: Text(
                'Reply',
                style: TextStyle(
                  color: isDarkMode
                      ? AppPalette.darkPrimary
                      : AppPalette.lightPrimary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],

          // Replies
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...comment.replies.map((reply) => CommentCard(
                  comment: reply,
                  currentUserId: currentUserId,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  isReply: true,
                )),
          ],
        ],
      ),
    );
  }
}
