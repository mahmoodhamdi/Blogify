import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/comments/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments({
    required String blogId,
    int page = 0,
    int limit = 20,
  });

  Future<CommentModel> addComment({
    required String blogId,
    required String userId,
    required String content,
    String? parentId,
  });

  Future<CommentModel> updateComment({
    required String commentId,
    required String content,
  });

  Future<void> deleteComment({
    required String commentId,
  });
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final SupabaseClient supabaseClient;
  CommentRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CommentModel>> getComments({
    required String blogId,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      // Fetch top-level comments (no parent_id)
      final comments = await supabaseClient
          .from('comments')
          .select('*, profiles (name, avatar_url)')
          .eq('blog_id', blogId)
          .isFilter('parent_id', null)
          .order('created_at', ascending: false)
          .range(start, end);

      // Fetch replies for each top-level comment
      final List<CommentModel> result = [];
      for (final commentData in comments) {
        final comment = CommentModel.fromJson(commentData);

        // Fetch replies for this comment
        final replies = await supabaseClient
            .from('comments')
            .select('*, profiles (name, avatar_url)')
            .eq('parent_id', comment.id)
            .order('created_at', ascending: true);

        final replyModels = replies
            .map((reply) => CommentModel.fromJson(reply))
            .toList();

        result.add(comment.copyWith(replies: replyModels));
      }

      return result;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> addComment({
    required String blogId,
    required String userId,
    required String content,
    String? parentId,
  }) async {
    try {
      final commentData = await supabaseClient.from('comments').insert({
        'blog_id': blogId,
        'user_id': userId,
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      }).select('*, profiles (name, avatar_url)');

      return CommentModel.fromJson(commentData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      final commentData = await supabaseClient
          .from('comments')
          .update({
            'content': content,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', commentId)
          .select('*, profiles (name, avatar_url)');

      return CommentModel.fromJson(commentData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment({
    required String commentId,
  }) async {
    try {
      await supabaseClient.from('comments').delete().eq('id', commentId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
