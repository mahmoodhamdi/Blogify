import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String title;
  final String content;
  final String ?imageUrl;
  final List<String> ?topics;
  final String posterId;
  final String id;

  const BlogEntity({
    required this.title,
    required this.content,
      this.imageUrl,
      this.topics,
    required this.posterId,
    required this.id,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        imageUrl,
      
        topics,
        posterId,
        id,
      ];
}
