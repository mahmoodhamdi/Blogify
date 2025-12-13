import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String blogId;
  final String userId;
  final String? parentId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userName;
  final String? userAvatarUrl;
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.blogId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatarUrl,
    this.replies = const [],
  });

  bool get isReply => parentId != null;

  Comment copyWith({
    String? id,
    String? blogId,
    String? userId,
    String? parentId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userName,
    String? userAvatarUrl,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
        id,
        blogId,
        userId,
        parentId,
        content,
        createdAt,
        updatedAt,
        userName,
        userAvatarUrl,
        replies,
      ];
}
