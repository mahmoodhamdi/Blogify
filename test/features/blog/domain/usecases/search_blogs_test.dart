import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/domain/repositories/blog_repository.dart';
import 'package:blogify/features/blog/domain/usecases/search_blogs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlogRepository extends Mock implements BlogRepository {}

void main() {
  late SearchBlogs usecase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    usecase = SearchBlogs(mockBlogRepository);
  });

  final testBlogs = [
    Blog(
      id: 'blog-1',
      posterId: 'user-1',
      title: 'Flutter Development',
      content: 'Content about Flutter',
      imageUrl: 'https://example.com/image1.jpg',
      topics: ['Technology', 'Programming'],
      updatedAt: DateTime(2024, 1, 1),
      posterName: 'Test User',
    ),
    Blog(
      id: 'blog-2',
      posterId: 'user-2',
      title: 'Dart Programming',
      content: 'Content about Dart',
      imageUrl: 'https://example.com/image2.jpg',
      topics: ['Programming'],
      updatedAt: DateTime(2024, 1, 2),
      posterName: 'Another User',
    ),
  ];

  group('SearchBlogs', () {
    test('should return list of blogs matching the query', () async {
      // arrange
      when(() => mockBlogRepository.searchBlogs(
            query: 'Flutter',
            topics: null,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Right([testBlogs[0]]));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'Flutter',
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (r) {
          expect(r.length, 1);
          expect(r[0].title, 'Flutter Development');
        },
      );
      verify(() => mockBlogRepository.searchBlogs(
            query: 'Flutter',
            topics: null,
            page: 0,
            limit: 10,
          )).called(1);
    });

    test('should return list of blogs filtered by topics', () async {
      // arrange
      when(() => mockBlogRepository.searchBlogs(
            query: '',
            topics: ['Programming'],
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Right(testBlogs));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: '',
        topics: ['Programming'],
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (r) => expect(r.length, 2),
      );
    });

    test('should return empty list when no blogs match', () async {
      // arrange
      when(() => mockBlogRepository.searchBlogs(
            query: 'NonExistent',
            topics: null,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'NonExistent',
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
      when(() => mockBlogRepository.searchBlogs(
            query: 'test',
            topics: null,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'test',
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
      when(() => mockBlogRepository.searchBlogs(
            query: 'test',
            topics: null,
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'test',
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

    test('should support pagination', () async {
      // arrange
      when(() => mockBlogRepository.searchBlogs(
            query: 'test',
            topics: null,
            page: 1,
            limit: 10,
          )).thenAnswer((_) async => Right([testBlogs[1]]));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'test',
        page: 1,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      verify(() => mockBlogRepository.searchBlogs(
            query: 'test',
            topics: null,
            page: 1,
            limit: 10,
          )).called(1);
    });

    test('should support combined query and topics filter', () async {
      // arrange
      when(() => mockBlogRepository.searchBlogs(
            query: 'Flutter',
            topics: ['Technology'],
            page: 0,
            limit: 10,
          )).thenAnswer((_) async => Right([testBlogs[0]]));

      // act
      final result = await usecase(const SearchBlogsParams(
        query: 'Flutter',
        topics: ['Technology'],
        page: 0,
        limit: 10,
      ));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (r) {
          expect(r.length, 1);
          expect(r[0].topics, contains('Technology'));
        },
      );
    });
  });

  group('SearchBlogsParams', () {
    test('should create params with required query', () {
      // arrange & act
      const params = SearchBlogsParams(query: 'test');

      // assert
      expect(params.query, 'test');
      expect(params.topics, null);
      expect(params.page, 0);
      expect(params.limit, 10);
    });

    test('should create params with all values', () {
      // arrange & act
      const params = SearchBlogsParams(
        query: 'test',
        topics: ['Technology', 'Programming'],
        page: 2,
        limit: 20,
      );

      // assert
      expect(params.query, 'test');
      expect(params.topics, ['Technology', 'Programming']);
      expect(params.page, 2);
      expect(params.limit, 20);
    });
  });
}
