import 'package:equatable/equatable.dart';

enum NotificationType {
  like,
  comment,
  reply,
  follow,
}

class AppNotification extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? blogId;
  final String? commentId;
  final String? fromUserId;
  final String? fromUserName;
  final String? fromUserAvatarUrl;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.blogId,
    this.commentId,
    this.fromUserId,
    this.fromUserName,
    this.fromUserAvatarUrl,
    this.isRead = false,
    required this.createdAt,
  });

  AppNotification copyWith({
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
    return AppNotification(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        blogId,
        commentId,
        fromUserId,
        fromUserName,
        fromUserAvatarUrl,
        isRead,
        createdAt,
      ];
}
