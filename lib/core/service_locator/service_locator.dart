import 'package:blogify/features/auth/data/data_sources/remote_data_source.dart';
import 'package:blogify/features/auth/data/repository/auth_rempository_impl.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final supabase = await Supabase.initialize(
      debug: true,
      url: "https://moeekwhegkshybyopjly.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1vZWVrd2hlZ2tzaHlieW9wamx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1ODc2OTYsImV4cCI6MjAzOTE2MzY5Nn0.56M3uloQsYEKswUXkhuxaww5yXUgdscWyXoF7KDtufY");
  final supabaseClient = supabase.client;
  getIt.registerSingleton<RemoteDataSourceImpl>(
      RemoteDataSourceImpl(supabase: supabaseClient));
  getIt.registerSingleton<AuthRepositoryImpl>(
      AuthRepositoryImpl(remoteDataSource: getIt<RemoteDataSourceImpl>()));

  getIt.registerSingleton<UserSignUpUseCase>(
      UserSignUpUseCase(authRepository: getIt<AuthRepositoryImpl>()));
  getIt.registerSingleton<AuthBloc>(
      AuthBloc(userSignUpUseCase: getIt<UserSignUpUseCase>()));
}
