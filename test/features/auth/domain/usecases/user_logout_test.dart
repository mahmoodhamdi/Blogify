import 'package:blogify/core/error/failures.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/features/auth/domain/repository/auth_repository.dart';
import 'package:blogify/features/auth/domain/usecases/user_logout.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UserLogout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = UserLogout(mockAuthRepository);
  });

  group('UserLogout', () {
    test('should call logout from the repository', () async {
      // arrange
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when logout fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Logout failed');
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when network error occurs', () async {
      // arrange
      const failure = NetworkFailure();
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });
  });
}
