import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/network/connection_checker.dart';
import 'package:blogify/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;
  final ConnectionChecker connectionChecker;

  NotificationRepositoryImpl(
    this.notificationRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required String userId,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final notifications = await notificationRemoteDataSource.getNotifications(
        userId: userId,
        page: page,
        limit: limit,
      );
      return right(notifications);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String notificationId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      await notificationRemoteDataSource.markAsRead(
        notificationId: notificationId,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead({
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      await notificationRemoteDataSource.markAllAsRead(userId: userId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      await notificationRemoteDataSource.deleteNotification(
        notificationId: notificationId,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount({
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const NetworkFailure());
      }
      final count = await notificationRemoteDataSource.getUnreadCount(
        userId: userId,
      );
      return right(count);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
