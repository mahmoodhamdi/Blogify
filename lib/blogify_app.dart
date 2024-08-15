import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogify/blogify.dart';
import 'package:blogify/core/service_locator/service_locator.dart';

class BlogifyApp extends StatelessWidget {
  const BlogifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<AppUserCubit>()),
      ],
      child: const Blogify(),
    );
  }
}
