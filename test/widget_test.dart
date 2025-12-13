// This is a basic Flutter widget test for Blogify.

import 'package:blogify/main.dart';
import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockBlogBloc extends Mock implements BlogBloc {}

class MockAppUserCubit extends Mock implements AppUserCubit {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockBlogBloc mockBlogBloc;
  late MockAppUserCubit mockAppUserCubit;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockBlogBloc = MockBlogBloc();
    mockAppUserCubit = MockAppUserCubit();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBlogBloc.state).thenReturn(BlogInitial());
    when(() => mockBlogBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAppUserCubit.state).thenReturn(AppUserInitial());
    when(() => mockAppUserCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('Blogify app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppUserCubit>.value(value: mockAppUserCubit),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<BlogBloc>.value(value: mockBlogBloc),
        ],
        child: const Blogify(),
      ),
    );

    // Verify the app title is displayed
    expect(find.text('Blogify'), findsOneWidget);
  });
}
