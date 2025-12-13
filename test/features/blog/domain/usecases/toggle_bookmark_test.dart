import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:blogify/features/blog/domain/usecases/toggle_bookmark.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlogRepository extends Mock implements BlogRepository {}

void main() {
  late ToggleBookmark usecase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    usecase = ToggleBookmark(mockBlogRepository);
  });

  const testBlogId = 'test-blog-id-123';
  const testUserId = 'test-user-id-456';

  final testBlog = Blog(
    id: testBlogId,
    posterId: 'poster-id',
    title: 'Test Blog',
    content: 'Test content',
    imageUrl: 'https://example.com/image.jpg',
    topics: ['Technology'],
    updatedAt: DateTime.now(),
    isBookmarked: true,
  );

  group('ToggleBookmark', () {
    test('should call toggleBookmark from the repository and return bookmarked blog',
        () async {
      // arrange
      when(() => mockBlogRepository.toggleBookmark(
            blogId: testBlogId,
            userId: testUserId,
          )).thenAnswer((_) async => Right(testBlog));

      // act
      final result = await usecase(const ToggleBookmarkParams(
        blogId: testBlogId,
        userId: testUserId,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return blog'),
        (r) {
          expect(r.id, testBlogId);
          expect(r.isBookmarked, true);
        },
      );
      verify(() => mockBlogRepository.toggleBookmark(
            blogId: testBlogId,
            userId: testUserId,
          )).called(1);
    });

    test('should return failure when toggle bookmark fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Failed to toggle bookmark');
      when(() => mockBlogRepository.toggleBookmark(
            blogId: testBlogId,
            userId: testUserId,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const ToggleBookmarkParams(
        blogId: testBlogId,
        userId: testUserId,
      ));

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when no internet connection', () async {
      // arrange
      const failure = NetworkFailure();
      when(() => mockBlogRepository.toggleBookmark(
            blogId: testBlogId,
            userId: testUserId,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const ToggleBookmarkParams(
        blogId: testBlogId,
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

  group('ToggleBookmarkParams', () {
    test('should create params with blogId and userId', () {
      // arrange & act
      const params = ToggleBookmarkParams(
        blogId: testBlogId,
        userId: testUserId,
      );

      // assert
      expect(params.blogId, testBlogId);
      expect(params.userId, testUserId);
    });
  });
}
