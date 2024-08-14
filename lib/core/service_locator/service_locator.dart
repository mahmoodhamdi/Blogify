import 'package:blogify/features/auth/data/data_sources/remote_data_source.dart';
import 'package:blogify/features/auth/data/repository/auth_rempository_impl.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final supabase = await Supabase.initialize(
    url: 'https://vqwlzbeqhpedsvvlljve.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxd2x6YmVxaHBlZHN2dmxsanZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2MjA4MTgsImV4cCI6MjAzOTE5NjgxOH0.vpRT3MZpu1xH7AQJMcmT3Wy-48JDGCl8OJxCLLynaA8',
  );
  final supabaseClient = supabase.client;
  getIt.registerFactory<RemoteDataSourceImpl>(
      () => RemoteDataSourceImpl(supabaseClient: supabaseClient));
  getIt.registerSingleton<AuthRepositoryImpl>(
      AuthRepositoryImpl(remoteDataSource: getIt<RemoteDataSourceImpl>()));

  getIt.registerFactory<UserSignUpUseCase>(
      () => UserSignUpUseCase(authRepository: getIt<AuthRepositoryImpl>()));
  getIt.registerFactory<UserSignInUseCase>(
      () => UserSignInUseCase(authRepository: getIt<AuthRepositoryImpl>()));

  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
      userSignUpUseCase: getIt<UserSignUpUseCase>(),
      userSignInUseCase: getIt<UserSignInUseCase>()));
}
