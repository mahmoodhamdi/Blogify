import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAllNotificationsRead implements UseCase<void, MarkAllNotificationsReadParams> {
  final NotificationRepository notificationRepository;
  const MarkAllNotificationsRead(this.notificationRepository);

  @override
  Future<Either<Failure, void>> call(MarkAllNotificationsReadParams params) async {
    return await notificationRepository.markAllAsRead(
      userId: params.userId,
    );
  }
}

class MarkAllNotificationsReadParams {
  final String userId;

  const MarkAllNotificationsReadParams({
    required this.userId,
  });
}
