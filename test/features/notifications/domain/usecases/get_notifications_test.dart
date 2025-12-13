import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:blogify/features/notifications/domain/usecases/get_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late GetNotifications usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = GetNotifications(mockRepository);
  });

  final tNotifications = [
    AppNotification(
      id: '1',
      userId: 'user-1',
      type: NotificationType.like,
      title: 'New Like',
      message: 'Someone liked your blog',
      blogId: 'blog-1',
      fromUserId: 'user-2',
      fromUserName: 'Test User',
      isRead: false,
      createdAt: DateTime.now(),
    ),
    AppNotification(
      id: '2',
      userId: 'user-1',
      type: NotificationType.comment,
      title: 'New Comment',
      message: 'Someone commented on your blog',
      blogId: 'blog-1',
      fromUserId: 'user-3',
      fromUserName: 'Another User',
      isRead: true,
      createdAt: DateTime.now(),
    ),
  ];

  test('should return list of notifications for user', () async {
    when(() => mockRepository.getNotifications(
          userId: any(named: 'userId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => Right(tNotifications));

    final result = await usecase(GetNotificationsParams(
      userId: 'user-1',
      page: 0,
      limit: 20,
    ));

    expect(result, Right(tNotifications));
    verify(() => mockRepository.getNotifications(
          userId: 'user-1',
          page: 0,
          limit: 20,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when no notifications', () async {
    when(() => mockRepository.getNotifications(
          userId: any(named: 'userId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => const Right([]));

    final result = await usecase(GetNotificationsParams(
      userId: 'user-1',
      page: 0,
      limit: 20,
    ));

    expect(result, const Right<Failure, List<AppNotification>>([]));
    verify(() => mockRepository.getNotifications(
          userId: 'user-1',
          page: 0,
          limit: 20,
        )).called(1);
  });

  test('should return failure when network error', () async {
    when(() => mockRepository.getNotifications(
          userId: any(named: 'userId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await usecase(GetNotificationsParams(
      userId: 'user-1',
      page: 0,
      limit: 20,
    ));

    expect(result, const Left(NetworkFailure()));
    verify(() => mockRepository.getNotifications(
          userId: 'user-1',
          page: 0,
          limit: 20,
        )).called(1);
  });

  test('should pass pagination parameters correctly', () async {
    when(() => mockRepository.getNotifications(
          userId: any(named: 'userId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => Right(tNotifications));

    await usecase(GetNotificationsParams(
      userId: 'user-1',
      page: 2,
      limit: 10,
    ));

    verify(() => mockRepository.getNotifications(
          userId: 'user-1',
          page: 2,
          limit: 10,
        )).called(1);
  });
}
