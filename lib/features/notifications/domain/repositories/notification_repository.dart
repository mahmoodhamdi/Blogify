import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:dartz/dartz.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required String userId,
    int page = 0,
    int limit = 20,
  });

  Future<Either<Failure, void>> markAsRead({
    required String notificationId,
  });

  Future<Either<Failure, void>> markAllAsRead({
    required String userId,
  });

  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
  });

  Future<Either<Failure, int>> getUnreadCount({
    required String userId,
  });
}
