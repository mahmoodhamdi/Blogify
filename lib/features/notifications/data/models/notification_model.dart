import 'package:blogify/features/notifications/domain/entities/notification.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.message,
    super.blogId,
    super.commentId,
    super.fromUserId,
    super.fromUserName,
    super.fromUserAvatarUrl,
    super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: _parseType(map['type'] as String),
      title: map['title'] as String,
      message: map['message'] as String,
      blogId: map['blog_id'] as String?,
      commentId: map['comment_id'] as String?,
      fromUserId: map['from_user_id'] as String?,
      fromUserName: map['from_user']?['name'] as String?,
      fromUserAvatarUrl: map['from_user']?['avatar_url'] as String?,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
    );
  }

  static NotificationType _parseType(String type) {
    switch (type) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'reply':
        return NotificationType.reply;
      case 'follow':
        return NotificationType.follow;
      default:
        return NotificationType.like;
    }
  }

  @override
  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? blogId,
    String? commentId,
    String? fromUserId,
    String? fromUserName,
    String? fromUserAvatarUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      blogId: blogId ?? this.blogId,
      commentId: commentId ?? this.commentId,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      fromUserAvatarUrl: fromUserAvatarUrl ?? this.fromUserAvatarUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
