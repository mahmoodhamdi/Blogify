import 'dart:io';

import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/auth/data/models/user_model.dart';
import 'package:blogify/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<BlogModel>> getUserBlogs({
    required String userId,
    int page = 0,
    int limit = 10,
  });

  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    File? avatarImage,
  });

  Future<String> uploadAvatar({
    required String userId,
    required File image,
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

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File image,
  }) async {
    try {
      final fileExt = image.path.split('.').last;
      final fileName = '$userId/avatar.$fileExt';

      await supabaseClient.storage.from('profile_avatars').upload(
            fileName,
            image,
            fileOptions: const FileOptions(upsert: true),
          );

      return supabaseClient.storage
          .from('profile_avatars')
          .getPublicUrl(fileName);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    File? avatarImage,
  }) async {
    try {
      String? avatarUrl;

      // Upload avatar if provided
      if (avatarImage != null) {
        avatarUrl = await uploadAvatar(userId: userId, image: avatarImage);
      }

      // Update profile in database
      final updateData = <String, dynamic>{'name': name};
      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }

      final response = await supabaseClient
          .from('profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
