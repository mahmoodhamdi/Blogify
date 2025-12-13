import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<BlogModel>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<BlogModel>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .eq('poster_id', userId)
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
