import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:blogify/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MarkAllNotificationsRead usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = MarkAllNotificationsRead(mockRepository);
  });

  test('should mark all notifications as read successfully', () async {
    when(() => mockRepository.markAllAsRead(
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(MarkAllNotificationsReadParams(
      userId: 'user-1',
    ));

    expect(result, const Right(null));
    verify(() => mockRepository.markAllAsRead(
          userId: 'user-1',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when marking all as read fails', () async {
    when(() => mockRepository.markAllAsRead(
          userId: any(named: 'userId'),
        )).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server error')));

    final result = await usecase(MarkAllNotificationsReadParams(
      userId: 'user-1',
    ));

    expect(result, const Left(ServerFailure(message: 'Server error')));
    verify(() => mockRepository.markAllAsRead(
          userId: 'user-1',
        )).called(1);
  });

  test('should return failure when network error', () async {
    when(() => mockRepository.markAllAsRead(
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await usecase(MarkAllNotificationsReadParams(
      userId: 'user-1',
    ));

    expect(result, const Left(NetworkFailure()));
    verify(() => mockRepository.markAllAsRead(
          userId: 'user-1',
        )).called(1);
  });
}
