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

  Future<BlogModel> toggleLike({
    required String blogId,
    required String userId,
  });

  Future<BlogModel> toggleBookmark({
    required String blogId,
    required String userId,
  });

  Future<List<BlogModel>> getBookmarkedBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });

  Future<bool> isLiked({
    required String blogId,
    required String userId,
  });

  Future<bool> isBookmarked({
    required String blogId,
    required String userId,
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

  @override
  Future<bool> isLiked({
    required String blogId,
    required String userId,
  }) async {
    try {
      final result = await supabaseClient
          .from('likes')
          .select()
          .eq('blog_id', blogId)
          .eq('user_id', userId)
          .maybeSingle();
      return result != null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isBookmarked({
    required String blogId,
    required String userId,
  }) async {
    try {
      final result = await supabaseClient
          .from('bookmarks')
          .select()
          .eq('blog_id', blogId)
          .eq('user_id', userId)
          .maybeSingle();
      return result != null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> toggleLike({
    required String blogId,
    required String userId,
  }) async {
    try {
      final existingLike = await supabaseClient
          .from('likes')
          .select()
          .eq('blog_id', blogId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike - delete the like
        await supabaseClient
            .from('likes')
            .delete()
            .eq('blog_id', blogId)
            .eq('user_id', userId);
      } else {
        // Like - insert new like
        await supabaseClient.from('likes').insert({
          'blog_id': blogId,
          'user_id': userId,
        });
      }

      // Fetch updated blog
      final blog = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .eq('id', blogId)
          .single();

      final isNowLiked = existingLike == null;
      return BlogModel.fromJson(blog).copyWith(
        posterName: blog['profiles']['name'],
        isLiked: isNowLiked,
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> toggleBookmark({
    required String blogId,
    required String userId,
  }) async {
    try {
      final existingBookmark = await supabaseClient
          .from('bookmarks')
          .select()
          .eq('blog_id', blogId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingBookmark != null) {
        // Remove bookmark
        await supabaseClient
            .from('bookmarks')
            .delete()
            .eq('blog_id', blogId)
            .eq('user_id', userId);
      } else {
        // Add bookmark
        await supabaseClient.from('bookmarks').insert({
          'blog_id': blogId,
          'user_id': userId,
        });
      }

      // Fetch updated blog
      final blog = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .eq('id', blogId)
          .single();

      final isNowBookmarked = existingBookmark == null;
      return BlogModel.fromJson(blog).copyWith(
        posterName: blog['profiles']['name'],
        isBookmarked: isNowBookmarked,
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBookmarkedBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      // Get bookmarked blog IDs for this user
      final bookmarks = await supabaseClient
          .from('bookmarks')
          .select('blog_id')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(start, end);

      if (bookmarks.isEmpty) {
        return [];
      }

      final blogIds = bookmarks.map((b) => b['blog_id'] as String).toList();

      // Fetch the blogs
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .inFilter('id', blogIds);

      // Sort by bookmark order and mark as bookmarked
      return blogIds
          .map((id) {
            final blogData = blogs.firstWhere(
              (b) => b['id'] == id,
              orElse: () => <String, dynamic>{},
            );
            if (blogData.isEmpty) return null;
            return BlogModel.fromJson(blogData).copyWith(
              posterName: blogData['profiles']['name'],
              isBookmarked: true,
            );
          })
          .whereType<BlogModel>()
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
