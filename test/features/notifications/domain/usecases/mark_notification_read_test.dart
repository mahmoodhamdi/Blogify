import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:blogify/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MarkNotificationRead usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = MarkNotificationRead(mockRepository);
  });

  test('should mark notification as read successfully', () async {
    when(() => mockRepository.markAsRead(
          notificationId: any(named: 'notificationId'),
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(MarkNotificationReadParams(
      notificationId: 'notification-1',
    ));

    expect(result, const Right(null));
    verify(() => mockRepository.markAsRead(
          notificationId: 'notification-1',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when marking as read fails', () async {
    when(() => mockRepository.markAsRead(
          notificationId: any(named: 'notificationId'),
        )).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server error')));

    final result = await usecase(MarkNotificationReadParams(
      notificationId: 'notification-1',
    ));

    expect(result, const Left(ServerFailure(message: 'Server error')));
    verify(() => mockRepository.markAsRead(
          notificationId: 'notification-1',
        )).called(1);
  });

  test('should return failure when network error', () async {
    when(() => mockRepository.markAsRead(
          notificationId: any(named: 'notificationId'),
        )).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await usecase(MarkNotificationReadParams(
      notificationId: 'notification-1',
    ));

    expect(result, const Left(NetworkFailure()));
    verify(() => mockRepository.markAsRead(
          notificationId: 'notification-1',
        )).called(1);
  });
}
