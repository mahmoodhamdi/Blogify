part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {
  final bool refresh;
  BlogFetchAllBlogs({this.refresh = false});
}

final class BlogFetchMoreBlogs extends BlogEvent {}

final class BlogDelete extends BlogEvent {
  final String blogId;

  BlogDelete({required this.blogId});
}

final class BlogUpdate extends BlogEvent {
  final String blogId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;

  BlogUpdate({
    required this.blogId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

final class BlogSearch extends BlogEvent {
  final String query;
  final List<String>? topics;

  BlogSearch({
    required this.query,
    this.topics,
  });
}

final class BlogSearchMoreResults extends BlogEvent {}

final class BlogClearSearch extends BlogEvent {}

final class BlogToggleLike extends BlogEvent {
  final String blogId;
  final String userId;

  BlogToggleLike({
    required this.blogId,
    required this.userId,
  });
}

final class BlogToggleBookmark extends BlogEvent {
  final String blogId;
  final String userId;

  BlogToggleBookmark({
    required this.blogId,
    required this.userId,
  });
}

final class BlogFetchBookmarks extends BlogEvent {
  final String userId;

  BlogFetchBookmarks({required this.userId});
}

final class BlogFetchMoreBookmarks extends BlogEvent {
  final String userId;

  BlogFetchMoreBookmarks({required this.userId});
}
