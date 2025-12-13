import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:blogify/features/blog/domain/usecases/get_bookmarked_blogs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlogRepository extends Mock implements BlogRepository {}

void main() {
  late GetBookmarkedBlogs usecase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    usecase = GetBookmarkedBlogs(mockBlogRepository);
  });

  const testUserId = 'test-user-id-456';

  final testBlogs = [
    Blog(
      id: 'blog-1',
      posterId: 'poster-id',
      title: 'Test Blog 1',
      content: 'Test content 1',
      imageUrl: 'https://example.com/image1.jpg',
      topics: ['Technology'],
      updatedAt: DateTime.now(),
      isBookmarked: true,
    ),
    Blog(
      id: 'blog-2',
      posterId: 'poster-id',
      title: 'Test Blog 2',
      content: 'Test content 2',
      imageUrl: 'https://example.com/image2.jpg',
      topics: ['Science'],
      updatedAt: DateTime.now(),
      isBookmarked: true,
    ),
  ];

  group('GetBookmarkedBlogs', () {
    test('should call getBookmarkedBlogs from the repository and return list of blogs',
        () async {
      // arrange
      when(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Right(testBlogs));

      // act
      final result = await usecase(const GetBookmarkedBlogsParams(
        userId: testUserId,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return list of blogs'),
        (r) {
          expect(r.length, 2);
          expect(r.first.isBookmarked, true);
        },
      );
      verify(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).called(1);
    });

    test('should return empty list when no bookmarks', () async {
      // arrange
      when(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(const GetBookmarkedBlogsParams(
        userId: testUserId,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return empty list'),
        (r) => expect(r.isEmpty, true),
      );
    });

    test('should pass pagination parameters correctly', () async {
      // arrange
      when(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 2,
            limit: 20,
          )).thenAnswer((_) async => Right(testBlogs));

      // act
      final result = await usecase(const GetBookmarkedBlogsParams(
        userId: testUserId,
        page: 2,
        limit: 20,
      ));

      // assert
      expect(result.isRight(), true);
      verify(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 2,
            limit: 20,
          )).called(1);
    });

    test('should return failure when fetching bookmarks fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Failed to fetch bookmarks');
      when(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const GetBookmarkedBlogsParams(
        userId: testUserId,
      ));

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when no internet connection', () async {
      // arrange
      const failure = NetworkFailure();
      when(() => mockBlogRepository.getBookmarkedBlogs(
            userId: testUserId,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const GetBookmarkedBlogsParams(
        userId: testUserId,
      ));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('GetBookmarkedBlogsParams', () {
    test('should create params with userId and default pagination', () {
      // arrange & act
      const params = GetBookmarkedBlogsParams(userId: testUserId);

      // assert
      expect(params.userId, testUserId);
      expect(params.page, 0);
      expect(params.limit, 10);
    });

    test('should create params with custom pagination', () {
      // arrange & act
      const params = GetBookmarkedBlogsParams(
        userId: testUserId,
        page: 5,
        limit: 25,
      );

      // assert
      expect(params.userId, testUserId);
      expect(params.page, 5);
      expect(params.limit, 25);
    });
  });
}
