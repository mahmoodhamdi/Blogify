import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/notifications/domain/repositories/notification_repository.dart';
import 'package:blogify/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late GetUnreadCount usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = GetUnreadCount(mockRepository);
  });

  test('should return unread count for user', () async {
    when(() => mockRepository.getUnreadCount(
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Right(5));

    final result = await usecase(GetUnreadCountParams(
      userId: 'user-1',
    ));

    expect(result, const Right(5));
    verify(() => mockRepository.getUnreadCount(
          userId: 'user-1',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return zero when no unread notifications', () async {
    when(() => mockRepository.getUnreadCount(
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Right(0));

    final result = await usecase(GetUnreadCountParams(
      userId: 'user-1',
    ));

    expect(result, const Right(0));
    verify(() => mockRepository.getUnreadCount(
          userId: 'user-1',
        )).called(1);
  });

  test('should return failure when network error', () async {
    when(() => mockRepository.getUnreadCount(
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await usecase(GetUnreadCountParams(
      userId: 'user-1',
    ));

    expect(result, const Left(NetworkFailure()));
    verify(() => mockRepository.getUnreadCount(
          userId: 'user-1',
        )).called(1);
  });

  test('should return failure when server error', () async {
    when(() => mockRepository.getUnreadCount(
          userId: any(named: 'userId'),
        )).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server error')));

    final result = await usecase(GetUnreadCountParams(
      userId: 'user-1',
    ));

    expect(result, const Left(ServerFailure(message: 'Server error')));
    verify(() => mockRepository.getUnreadCount(
          userId: 'user-1',
        )).called(1);
  });
}
