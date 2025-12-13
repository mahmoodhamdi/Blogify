// This is a basic Flutter widget test for Blogify.

import 'package:blogify/main.dart';
import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/cubits/theme/theme_cubit.dart';
import 'package:blogify/core/common/cubits/theme/theme_state.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockBlogBloc extends Mock implements BlogBloc {}

class MockAppUserCubit extends Mock implements AppUserCubit {}

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockBlogBloc mockBlogBloc;
  late MockAppUserCubit mockAppUserCubit;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockBlogBloc = MockBlogBloc();
    mockAppUserCubit = MockAppUserCubit();
    mockThemeCubit = MockThemeCubit();

    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBlogBloc.state).thenReturn(const BlogInitial());
    when(() => mockBlogBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAppUserCubit.state).thenReturn(const AppUserInitial());
    when(() => mockAppUserCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockThemeCubit.state)
        .thenReturn(const ThemeState(themeMode: ThemeMode.system));
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('Blogify app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppUserCubit>.value(value: mockAppUserCubit),
          BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
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
