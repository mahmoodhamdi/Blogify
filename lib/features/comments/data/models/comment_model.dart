import 'package:blogify/features/comments/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.blogId,
    required super.userId,
    super.parentId,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.userName,
    super.userAvatarUrl,
    super.replies,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'blog_id': blogId,
      'user_id': userId,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Returns a map for creating a new comment (excludes id, timestamps).
  Map<String, dynamic> toCreateJson() {
    return <String, dynamic>{
      'blog_id': blogId,
      'user_id': userId,
      if (parentId != null) 'parent_id': parentId,
      'content': content,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      blogId: map['blog_id'] as String,
      userId: map['user_id'] as String,
      parentId: map['parent_id'] as String?,
      content: map['content'] as String,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      userName: map['profiles']?['name'] as String?,
      userAvatarUrl: map['profiles']?['avatar_url'] as String?,
    );
  }

  @override
  CommentModel copyWith({
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
    return CommentModel(
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
}
