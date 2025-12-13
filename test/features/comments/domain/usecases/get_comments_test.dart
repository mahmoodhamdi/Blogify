import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:blogify/features/comments/domain/usecases/get_comments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late GetComments usecase;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    usecase = GetComments(mockRepository);
  });

  const testBlogId = 'test-blog-id';

  final testComments = [
    Comment(
      id: 'comment-1',
      blogId: testBlogId,
      userId: 'user-1',
      content: 'Great post!',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userName: 'John Doe',
    ),
    Comment(
      id: 'comment-2',
      blogId: testBlogId,
      userId: 'user-2',
      content: 'Nice article!',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userName: 'Jane Doe',
    ),
  ];

  group('GetComments', () {
    test('should return list of comments for blog', () async {
      when(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 0,
            limit: 20,
          )).thenAnswer((_) async => Right(testComments));

      final result = await usecase(const GetCommentsParams(blogId: testBlogId));

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return comments'),
        (r) => expect(r.length, 2),
      );
      verify(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 0,
            limit: 20,
          )).called(1);
    });

    test('should return empty list when no comments', () async {
      when(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 0,
            limit: 20,
          )).thenAnswer((_) async => const Right([]));

      final result = await usecase(const GetCommentsParams(blogId: testBlogId));

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return empty list'),
        (r) => expect(r.isEmpty, true),
      );
    });

    test('should return failure when network error', () async {
      when(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 0,
            limit: 20,
          )).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase(const GetCommentsParams(blogId: testBlogId));

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });

    test('should pass pagination parameters correctly', () async {
      when(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 2,
            limit: 10,
          )).thenAnswer((_) async => Right(testComments));

      await usecase(const GetCommentsParams(
        blogId: testBlogId,
        page: 2,
        limit: 10,
      ));

      verify(() => mockRepository.getComments(
            blogId: testBlogId,
            page: 2,
            limit: 10,
          )).called(1);
    });
  });
}
