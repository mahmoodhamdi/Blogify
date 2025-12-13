import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetNotifications implements UseCase<List<AppNotification>, GetNotificationsParams> {
  final NotificationRepository notificationRepository;
  const GetNotifications(this.notificationRepository);

  @override
  Future<Either<Failure, List<AppNotification>>> call(GetNotificationsParams params) async {
    return await notificationRepository.getNotifications(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetNotificationsParams {
  final String userId;
  final int page;
  final int limit;

  const GetNotificationsParams({
    required this.userId,
    this.page = 0,
    this.limit = 20,
  });
}
