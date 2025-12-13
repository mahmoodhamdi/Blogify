import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:blogify/features/blog/domain/usecases/delete_blog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlogRepository extends Mock implements BlogRepository {}

void main() {
  late DeleteBlog usecase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    usecase = DeleteBlog(mockBlogRepository);
  });

  const testBlogId = 'test-blog-id-123';

  group('DeleteBlog', () {
    test('should call deleteBlog from the repository with correct blogId',
        () async {
      // arrange
      when(() => mockBlogRepository.deleteBlog(blogId: testBlogId))
          .thenAnswer((_) async => const Right(null));

      // act
      final result =
          await usecase(const DeleteBlogParams(blogId: testBlogId));

      // assert
      expect(result, const Right(null));
      verify(() => mockBlogRepository.deleteBlog(blogId: testBlogId)).called(1);
      verifyNoMoreInteractions(mockBlogRepository);
    });

    test('should return failure when deletion fails', () async {
      // arrange
      final failure = Failure('Failed to delete blog');
      when(() => mockBlogRepository.deleteBlog(blogId: testBlogId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result =
          await usecase(const DeleteBlogParams(blogId: testBlogId));

      // assert
      expect(result, Left(failure));
      verify(() => mockBlogRepository.deleteBlog(blogId: testBlogId)).called(1);
    });

    test('should return failure when no internet connection', () async {
      // arrange
      final failure = Failure('No internet connection');
      when(() => mockBlogRepository.deleteBlog(blogId: testBlogId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result =
          await usecase(const DeleteBlogParams(blogId: testBlogId));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'No internet connection'),
        (r) => fail('Should return failure'),
      );
    });

    test('should return failure when blog not found', () async {
      // arrange
      final failure = Failure('Blog not found');
      when(() => mockBlogRepository.deleteBlog(blogId: 'non-existent-id'))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(
          const DeleteBlogParams(blogId: 'non-existent-id'));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Blog not found'),
        (r) => fail('Should return failure'),
      );
    });

    test('should return failure when user is not authorized', () async {
      // arrange
      final failure = Failure('Not authorized to delete this blog');
      when(() => mockBlogRepository.deleteBlog(blogId: testBlogId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result =
          await usecase(const DeleteBlogParams(blogId: testBlogId));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Not authorized to delete this blog'),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('DeleteBlogParams', () {
    test('should create params with blogId', () {
      // arrange & act
      const params = DeleteBlogParams(blogId: testBlogId);

      // assert
      expect(params.blogId, testBlogId);
    });
  });
}
