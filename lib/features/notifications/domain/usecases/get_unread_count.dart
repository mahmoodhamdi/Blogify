import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetUnreadCount implements UseCase<int, GetUnreadCountParams> {
  final NotificationRepository notificationRepository;
  const GetUnreadCount(this.notificationRepository);

  @override
  Future<Either<Failure, int>> call(GetUnreadCountParams params) async {
    return await notificationRepository.getUnreadCount(
      userId: params.userId,
    );
  }
}

class GetUnreadCountParams {
  final String userId;

  const GetUnreadCountParams({
    required this.userId,
  });
}
