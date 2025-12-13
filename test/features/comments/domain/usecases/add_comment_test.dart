import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/comments/domain/entities/comment.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:blogify/features/comments/domain/usecases/add_comment.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late AddComment usecase;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    usecase = AddComment(mockRepository);
  });

  const testBlogId = 'test-blog-id';
  const testUserId = 'test-user-id';
  const testContent = 'This is a great post!';

  final testComment = Comment(
    id: 'comment-1',
    blogId: testBlogId,
    userId: testUserId,
    content: testContent,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userName: 'John Doe',
  );

  group('AddComment', () {
    test('should add comment and return it', () async {
      when(() => mockRepository.addComment(
            blogId: testBlogId,
            userId: testUserId,
            content: testContent,
            parentId: null,
          )).thenAnswer((_) async => Right(testComment));

      final result = await usecase(const AddCommentParams(
        blogId: testBlogId,
        userId: testUserId,
        content: testContent,
      ));

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return comment'),
        (r) {
          expect(r.blogId, testBlogId);
          expect(r.content, testContent);
        },
      );
    });

    test('should add reply with parentId', () async {
      const parentId = 'parent-comment-id';
      when(() => mockRepository.addComment(
            blogId: testBlogId,
            userId: testUserId,
            content: testContent,
            parentId: parentId,
          )).thenAnswer((_) async => Right(testComment.copyWith(parentId: parentId)));

      final result = await usecase(const AddCommentParams(
        blogId: testBlogId,
        userId: testUserId,
        content: testContent,
        parentId: parentId,
      ));

      expect(result.isRight(), true);
      verify(() => mockRepository.addComment(
            blogId: testBlogId,
            userId: testUserId,
            content: testContent,
            parentId: parentId,
          )).called(1);
    });

    test('should return failure when network error', () async {
      when(() => mockRepository.addComment(
            blogId: testBlogId,
            userId: testUserId,
            content: testContent,
            parentId: null,
          )).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase(const AddCommentParams(
        blogId: testBlogId,
        userId: testUserId,
        content: testContent,
      ));

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });
  });
}
