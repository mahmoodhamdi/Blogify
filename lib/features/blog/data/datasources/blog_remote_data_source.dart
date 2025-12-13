import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs({int page = 0, int limit = 10});
  Future<void> deleteBlog(String blogId);
  Future<BlogModel> updateBlog(BlogModel blog);
  Future<String> updateBlogImage({
    required File image,
    required String blogId,
  });
  Future<List<BlogModel>> searchBlogs({
    required String query,
    List<String>? topics,
    int page = 0,
    int limit = 10,
  });
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(
            blog.id,
          );
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs({int page = 0, int limit = 10}) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .order('updated_at', ascending: false)
          .range(start, end);

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      // Delete the blog image from storage
      await supabaseClient.storage.from('blog_images').remove([blogId]);

      // Delete the blog from the database
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> updateBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update(blog.toUpdateJson(includeImageUrl: blog.imageUrl.isNotEmpty))
          .eq('id', blog.id)
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateBlogImage({
    required File image,
    required String blogId,
  }) async {
    try {
      // Update (overwrite) the existing image
      await supabaseClient.storage.from('blog_images').update(
            blogId,
            image,
            fileOptions: const FileOptions(upsert: true),
          );

      // Return the public URL (add timestamp to bust cache)
      final url = supabaseClient.storage.from('blog_images').getPublicUrl(blogId);
      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> searchBlogs({
    required String query,
    List<String>? topics,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      var queryBuilder = supabaseClient
          .from('blogs')
          .select('*, profiles (name)');

      // Search in title and content using ilike for case-insensitive search
      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.or('title.ilike.%$query%,content.ilike.%$query%');
      }

      // Filter by topics if provided
      if (topics != null && topics.isNotEmpty) {
        queryBuilder = queryBuilder.overlaps('topics', topics);
      }

      final blogs = await queryBuilder
          .order('updated_at', ascending: false)
          .range(start, end);

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
