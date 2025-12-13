import 'dart:io';

import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:blogify/features/blog/domain/usecases/update_blog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlogRepository extends Mock implements BlogRepository {}

class MockFile extends Mock implements File {}

void main() {
  late UpdateBlog usecase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    usecase = UpdateBlog(mockBlogRepository);
  });

  setUpAll(() {
    registerFallbackValue(MockFile());
  });

  const testBlogId = 'test-blog-id-123';
  const testTitle = 'Updated Title';
  const testContent = 'Updated Content';
  const testTopics = ['Technology', 'Programming'];

  final testBlog = Blog(
    id: testBlogId,
    posterId: 'poster-id',
    title: testTitle,
    content: testContent,
    imageUrl: 'https://example.com/image.jpg',
    topics: testTopics,
    updatedAt: DateTime.now(),
    posterName: 'Test User',
  );

  group('UpdateBlog', () {
    test('should call updateBlog from the repository with correct parameters',
        () async {
      // arrange
      when(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: null,
          )).thenAnswer((_) async => Right(testBlog));

      // act
      final result = await usecase(
        const UpdateBlogParams(
          blogId: testBlogId,
          title: testTitle,
          content: testContent,
          topics: testTopics,
        ),
      );

      // assert
      expect(result.isRight(), true);
      verify(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: null,
          )).called(1);
    });

    test('should call updateBlog with image when image is provided', () async {
      // arrange
      final mockFile = MockFile();
      when(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: mockFile,
          )).thenAnswer((_) async => Right(testBlog));

      // act
      final result = await usecase(
        UpdateBlogParams(
          blogId: testBlogId,
          title: testTitle,
          content: testContent,
          topics: testTopics,
          image: mockFile,
        ),
      );

      // assert
      expect(result.isRight(), true);
      verify(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: mockFile,
          )).called(1);
    });

    test('should return failure when update fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Failed to update blog');
      when(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: null,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        const UpdateBlogParams(
          blogId: testBlogId,
          title: testTitle,
          content: testContent,
          topics: testTopics,
        ),
      );

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when no internet connection', () async {
      // arrange
      const failure = NetworkFailure();
      when(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: null,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        const UpdateBlogParams(
          blogId: testBlogId,
          title: testTitle,
          content: testContent,
          topics: testTopics,
        ),
      );

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });

    test('should return failure when user is not authorized', () async {
      // arrange
      const failure = AuthorizationFailure(message: 'Not authorized to update this blog');
      when(() => mockBlogRepository.updateBlog(
            blogId: testBlogId,
            title: testTitle,
            content: testContent,
            topics: testTopics,
            image: null,
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        const UpdateBlogParams(
          blogId: testBlogId,
          title: testTitle,
          content: testContent,
          topics: testTopics,
        ),
      );

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Not authorized to update this blog'),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('UpdateBlogParams', () {
    test('should create params with required fields', () {
      // arrange & act
      const params = UpdateBlogParams(
        blogId: testBlogId,
        title: testTitle,
        content: testContent,
        topics: testTopics,
      );

      // assert
      expect(params.blogId, testBlogId);
      expect(params.title, testTitle);
      expect(params.content, testContent);
      expect(params.topics, testTopics);
      expect(params.image, isNull);
    });

    test('should create params with optional image', () {
      // arrange & act
      final mockFile = MockFile();
      final params = UpdateBlogParams(
        blogId: testBlogId,
        title: testTitle,
        content: testContent,
        topics: testTopics,
        image: mockFile,
      );

      // assert
      expect(params.image, mockFile);
    });
  });
}
