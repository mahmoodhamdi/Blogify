import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/comments/domain/repositories/comment_repository.dart';
import 'package:blogify/features/comments/domain/usecases/delete_comment.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late DeleteComment usecase;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    usecase = DeleteComment(mockRepository);
  });

  const testCommentId = 'test-comment-id';

  group('DeleteComment', () {
    test('should delete comment successfully', () async {
      when(() => mockRepository.deleteComment(commentId: testCommentId))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(
        const DeleteCommentParams(commentId: testCommentId),
      );

      expect(result, const Right(null));
      verify(() => mockRepository.deleteComment(commentId: testCommentId))
          .called(1);
    });

    test('should return failure when delete fails', () async {
      when(() => mockRepository.deleteComment(commentId: testCommentId))
          .thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Failed to delete')),
      );

      final result = await usecase(
        const DeleteCommentParams(commentId: testCommentId),
      );

      expect(result.isLeft(), true);
    });

    test('should return failure when network error', () async {
      when(() => mockRepository.deleteComment(commentId: testCommentId))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase(
        const DeleteCommentParams(commentId: testCommentId),
      );

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('Should return failure'),
      );
    });
  });
}
