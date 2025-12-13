import 'package:bloc_test/bloc_test.dart';
import 'package:blogify/core/error/failures.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/profile/domain/usecases/get_user_blogs.dart';
import 'package:blogify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserBlogs extends Mock implements GetUserBlogs {}

void main() {
  late ProfileBloc profileBloc;
  late MockGetUserBlogs mockGetUserBlogs;

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

  setUp(() {
    mockGetUserBlogs = MockGetUserBlogs();
    profileBloc = ProfileBloc(getUserBlogs: mockGetUserBlogs);
  });

  tearDown(() {
    profileBloc.close();
  });

  setUpAll(() {
    registerFallbackValue(const GetUserBlogsParams(userId: ''));
  });

  test('initial state should be ProfileInitial', () {
    expect(profileBloc.state, const ProfileInitial());
  });

  group('ProfileFetchUserBlogs', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when successful',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => Right(testBlogs));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileFetchUserBlogs(userId: testUserId)),
      expect: () => [
        const ProfileLoading(),
        ProfileLoaded(
          blogs: testBlogs,
          userId: testUserId,
          hasReachedMax: true,
          currentPage: 0,
        ),
      ],
      verify: (_) {
        verify(() => mockGetUserBlogs(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] with hasReachedMax false when more blogs available',
      build: () {
        // Return exactly 10 blogs to indicate more may be available
        final manyBlogs = List.generate(
          10,
          (i) => Blog(
            id: 'blog-$i',
            posterId: testUserId,
            title: 'Test Blog $i',
            content: 'Content $i',
            imageUrl: 'https://example.com/image$i.jpg',
            topics: ['Technology'],
            updatedAt: DateTime(2024, 1, i + 1),
            posterName: 'Test User',
          ),
        );
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => Right(manyBlogs));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileFetchUserBlogs(userId: testUserId)),
      expect: () => [
        const ProfileLoading(),
        isA<ProfileLoaded>()
            .having((s) => s.blogs.length, 'blogs length', 10)
            .having((s) => s.hasReachedMax, 'hasReachedMax', false),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] with empty list when user has no blogs',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => const Right([]));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileFetchUserBlogs(userId: testUserId)),
      expect: () => [
        const ProfileLoading(),
        const ProfileLoaded(
          blogs: [],
          userId: testUserId,
          hasReachedMax: true,
          currentPage: 0,
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileFailure] when error occurs',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => Left(Failure('Server error')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileFetchUserBlogs(userId: testUserId)),
      expect: () => [
        const ProfileLoading(),
        const ProfileFailure('Server error'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileFailure] when no internet connection',
      build: () {
        when(() => mockGetUserBlogs(any())).thenAnswer(
            (_) async => Left(Failure('Not connected to a network!')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileFetchUserBlogs(userId: testUserId)),
      expect: () => [
        const ProfileLoading(),
        const ProfileFailure('Not connected to a network!'),
      ],
    );
  });

  group('ProfileFetchMoreBlogs', () {
    blocTest<ProfileBloc, ProfileState>(
      'fetches more blogs when not at max',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => Right(testBlogs));
        return profileBloc;
      },
      seed: () => ProfileLoaded(
        blogs: testBlogs,
        userId: testUserId,
        hasReachedMax: false,
        currentPage: 0,
      ),
      act: (bloc) => bloc.add(ProfileFetchMoreBlogs()),
      expect: () => [
        ProfileLoaded(
          blogs: [...testBlogs, ...testBlogs],
          userId: testUserId,
          hasReachedMax: true,
          currentPage: 1,
        ),
      ],
      verify: (_) {
        verify(() => mockGetUserBlogs(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'sets hasReachedMax true when empty result',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => const Right([]));
        return profileBloc;
      },
      seed: () => ProfileLoaded(
        blogs: testBlogs,
        userId: testUserId,
        hasReachedMax: false,
        currentPage: 0,
      ),
      act: (bloc) => bloc.add(ProfileFetchMoreBlogs()),
      expect: () => [
        ProfileLoaded(
          blogs: testBlogs,
          userId: testUserId,
          hasReachedMax: true,
          currentPage: 0,
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'does nothing when already at max',
      build: () => profileBloc,
      seed: () => ProfileLoaded(
        blogs: testBlogs,
        userId: testUserId,
        hasReachedMax: true,
        currentPage: 0,
      ),
      act: (bloc) => bloc.add(ProfileFetchMoreBlogs()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetUserBlogs(any()));
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileFailure when error occurs during fetch more',
      build: () {
        when(() => mockGetUserBlogs(any()))
            .thenAnswer((_) async => Left(Failure('Server error')));
        return profileBloc;
      },
      seed: () => ProfileLoaded(
        blogs: testBlogs,
        userId: testUserId,
        hasReachedMax: false,
        currentPage: 0,
      ),
      act: (bloc) => bloc.add(ProfileFetchMoreBlogs()),
      expect: () => [
        const ProfileFailure('Server error'),
      ],
    );
  });
}
