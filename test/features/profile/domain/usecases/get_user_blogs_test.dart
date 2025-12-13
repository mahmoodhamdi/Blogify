import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/profile/domain/repositories/profile_repository.dart';
import 'package:blogify/features/profile/domain/usecases/get_user_blogs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetUserBlogs usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = GetUserBlogs(mockProfileRepository);
  });

  const testUserId = 'test-user-id-123';
  final testBlogs = [
    Blog(
      id: 'blog-1',
      posterId: testUserId,
      title: 'Test Blog 1',
      content: 'Content 1',
      imageUrl: 'https://example.com/image1.jpg',
      topics: ['Technology'],
      updatedAt: DateTime(2024, 1, 1),
      posterName: 'Test User',
    ),
    Blog(
      id: 'blog-2',
      posterId: testUserId,
      title: 'Test Blog 2',
      content: 'Content 2',
      imageUrl: 'https://example.com/image2.jpg',
      topics: ['Programming'],
      updatedAt: DateTime(2024, 1, 2),
      posterName: 'Test User',
    ),
  ];

  group('GetUserBlogs', () {
    test('should return list of blogs for the user', () async {
      // arrange
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Right(testBlogs));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result, Right(testBlogs));
      verify(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });

    test('should return empty list when user has no blogs', () async {
      // arrange
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (r) => expect(r, isEmpty),
      );
    });

    test('should return failure when no internet connection', () async {
      // arrange
      final failure = Failure('Not connected to a network!');
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Not connected to a network!'),
        (r) => fail('Should return failure'),
      );
    });

    test('should return failure when server error occurs', () async {
      // arrange
      final failure = Failure('Server error');
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Server error'),
        (r) => fail('Should return failure'),
      );
    });

    test('should support pagination with different page numbers', () async {
      // arrange
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 1,
            limit: 10,
          )).thenAnswer((_) async => Right([testBlogs[1]]));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 1,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (r) => expect(r.length, 1),
      );
      verify(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 1,
            limit: 10,
          )).called(1);
    });

    test('should support different limit values', () async {
      // arrange
      when(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 5,
          )).thenAnswer((_) async => Right(testBlogs));

      // act
      final result = await usecase(const GetUserBlogsParams(
        userId: testUserId,
        page: 0,
        limit: 5,
      ));

      // assert
      expect(result.isRight(), true);
      verify(() => mockProfileRepository.getUserBlogs(
            userId: testUserId,
            page: 0,
            limit: 5,
          )).called(1);
    });
  });

  group('GetUserBlogsParams', () {
    test('should create params with default values', () {
      // arrange & act
      const params = GetUserBlogsParams(userId: testUserId);

      // assert
      expect(params.userId, testUserId);
      expect(params.page, 0);
      expect(params.limit, 10);
    });

    test('should create params with custom values', () {
      // arrange & act
      const params = GetUserBlogsParams(
        userId: testUserId,
        page: 2,
        limit: 20,
      );

      // assert
      expect(params.userId, testUserId);
      expect(params.page, 2);
      expect(params.limit, 20);
    });
  });
}
