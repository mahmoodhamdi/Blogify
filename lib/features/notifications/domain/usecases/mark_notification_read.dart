import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkNotificationRead implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepository notificationRepository;
  const MarkNotificationRead(this.notificationRepository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) async {
    return await notificationRepository.markAsRead(
      notificationId: params.notificationId,
    );
  }
}

class MarkNotificationReadParams {
  final String notificationId;

  const MarkNotificationReadParams({
    required this.notificationId,
  });
}
