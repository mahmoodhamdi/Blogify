import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/features/auth/data/data_sources/remote_data_source.dart';
import 'package:blogify/features/auth/data/repository/auth_rempository_impl.dart';
import 'package:blogify/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blogify/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blogify/features/blog/domain/usecases/add_blog_usecase.dart';
import 'package:blogify/features/blog/domain/usecases/get_all_blogs_usecase.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final supabase = await Supabase.initialize(
      url: 'https://cykqzxryzxsavgzdvzdd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5a3F6eHJ5enhzYXZnemR2emRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2MzE2MzQsImV4cCI6MjAzOTIwNzYzNH0.-U1eGQbbzxPNWnbBRiKGWp6aikNu7MlOlwCAJRrylH8');

  getIt.registerLazySingleton(() => supabase.client);
  getIt.registerFactory<RemoteDataSourceImpl>(
      () => RemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()));
  getIt.registerFactory<AuthRepositoryImpl>(() =>
      AuthRepositoryImpl(remoteDataSource: getIt<RemoteDataSourceImpl>()));

  getIt.registerFactory<UserSignUpUseCase>(
      () => UserSignUpUseCase(authRepository: getIt<AuthRepositoryImpl>()));
  getIt.registerFactory<UserSignInUseCase>(
      () => UserSignInUseCase(authRepository: getIt<AuthRepositoryImpl>()));
  getIt.registerFactory<GetCurrentUserUsecase>(
      () => GetCurrentUserUsecase(authRepository: getIt<AuthRepositoryImpl>()));
  getIt.registerFactory<AppUserCubit>(() => AppUserCubit());
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
      userSignUpUseCase: getIt<UserSignUpUseCase>(),
      userSignInUseCase: getIt<UserSignInUseCase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
      appUserCubit: getIt<AppUserCubit>()));
  getIt.registerFactory<BlogRemoteDataSourceImpl>(
    () => BlogRemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerFactory<BlogRepositoryImpl>(() => BlogRepositoryImpl(
      blogRemoteDataSource: getIt<BlogRemoteDataSourceImpl>()));

  getIt.registerFactory<AddBlogUsecase>(
    () => AddBlogUsecase(blogRepository: getIt<BlogRepositoryImpl>()),
  );
  getIt.registerFactory<GetAllBlogsUsecase>(
    () => GetAllBlogsUsecase(blogRepository: getIt<BlogRepositoryImpl>()),
  );
  getIt.registerFactory<BlogBloc>(() => BlogBloc(
        addBlogUsecase: getIt<AddBlogUsecase>(),
        getAllBlogsUsecase: getIt<GetAllBlogsUsecase>(),
      ));
}
