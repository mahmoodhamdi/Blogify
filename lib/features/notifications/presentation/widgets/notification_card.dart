import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkRead,
  });

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.reply:
        return Icons.reply;
      case NotificationType.follow:
        return Icons.person_add;
    }
  }

  Color _getNotificationColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (notification.type) {
      case NotificationType.like:
        return Colors.red.shade400;
      case NotificationType.comment:
        return isDark ? Colors.blue.shade300 : Colors.blue.shade600;
      case NotificationType.reply:
        return isDark ? Colors.green.shade300 : Colors.green.shade600;
      case NotificationType.follow:
        return isDark ? Colors.purple.shade300 : Colors.purple.shade600;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('d MMM').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? null
              : (isDark
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.primary.withValues(alpha: 0.05)),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        _getNotificationIcon(),
                        size: 14,
                        color: _getNotificationColor(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(notification.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!notification.isRead && onMarkRead != null)
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                onPressed: onMarkRead,
                tooltip: 'Mark as read',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          backgroundImage: notification.fromUserAvatarUrl != null
              ? CachedNetworkImageProvider(notification.fromUserAvatarUrl!)
              : null,
          child: notification.fromUserAvatarUrl == null
              ? Text(
                  (notification.fromUserName ?? 'U').substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getNotificationColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(),
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
