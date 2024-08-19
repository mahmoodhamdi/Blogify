part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

final class BlogUpload extends BlogEvent {
  final File? image;
  final String title;
  final String content;
  final String posterId;
  final List<String>? topics;

  const BlogUpload({
    this.image,
    required this.title,
    required this.content,
    required this.posterId,
    this.topics,
  });

  @override
  List<Object> get props => [
        title,
        content,
        posterId,
      ];
}

class GetAllBlogsEvent extends BlogEvent {
  const GetAllBlogsEvent();

  @override
  List<Object> get props => [];
}
