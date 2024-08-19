import 'package:blogify/features/blog/domain/entities/blog_entity.dart';

class BlogModel extends BlogEntity {
  const BlogModel(
      {required super.id,
      required super.title,
      required super.posterId,
      required super.content,
      // required super.updatedAt,
      super.imageUrl,
      super.topics});

//-- Create a table for public blogs
// create table blogs (
//   id uuid not null primary key,
//   updated_at timestamp with time zone,
//   poster_id uuid not null,
//   title text not null,
//   content text not null,
//   image_url text,
//   topics text array,
//   foreign key (poster_id) references public.profiles(id)
// );
  BlogModel.fromMap(Map<String, dynamic> map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          posterId: map['poster_id'] as String,
          content: map['content'] as String,
          // updatedAt: map['updated_at'],
          imageUrl: map['image_url'] as String,
          topics: map['topics'].toString().split(', '),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster_id': posterId,
      'content': content,
      // 'updated_at': updatedAt,
      'image_url': imageUrl,
      'topics': topics
    };
  }
  //copyWith

  BlogModel copyWithContent({String? content}) {
    return BlogModel(
        id: id,
        title: title,
        posterId: posterId,
        content: content ?? this.content,
        // updatedAt: updatedAt,
        imageUrl: imageUrl,
        topics: topics);
  }

  BlogModel copyWithTopics({List<String>? topics}) {
    return BlogModel(
        id: id,
        title: title,
        posterId: posterId,
        content: content,
        // updatedAt: updatedAt,
        imageUrl: imageUrl,
        topics: topics ?? this.topics);
  }

  BlogModel copyWithImageUrl({String? imageUrl}) {
    return BlogModel(
        id: id,
        title: title,
        posterId: posterId,
        content: content,
        //     updatedAt: updatedAt,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics);
  }
}
