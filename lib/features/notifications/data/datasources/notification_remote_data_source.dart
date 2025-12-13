import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/features/notifications/data/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int page = 0,
    int limit = 20,
  });

  Future<void> markAsRead({
    required String notificationId,
  });

  Future<void> markAllAsRead({
    required String userId,
  });

  Future<void> deleteNotification({
    required String notificationId,
  });

  Future<int> getUnreadCount({
    required String userId,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient supabaseClient;
  NotificationRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      final notifications = await supabaseClient
          .from('notifications')
          .select('*, from_user:from_user_id(name, avatar_url)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(start, end);

      return notifications
          .map((n) => NotificationModel.fromJson(n))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead({
    required String notificationId,
  }) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAllAsRead({
    required String userId,
  }) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteNotification({
    required String notificationId,
  }) async {
    try {
      await supabaseClient
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getUnreadCount({
    required String userId,
  }) async {
    try {
      final result = await supabaseClient
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);

      return result.count;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
