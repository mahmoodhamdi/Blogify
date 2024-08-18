import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String title;
  final String content;
  final String ?imageUrl;
  final DateTime updatedAt;
  final List<String> ?topics;
  final String posterId;
  final String id;

  const BlogEntity({
    required this.title,
    required this.content,
      this.imageUrl,
    required this.updatedAt,
      this.topics,
    required this.posterId,
    required this.id,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        imageUrl,
        updatedAt,
        topics,
        posterId,
        id,
      ];
}
