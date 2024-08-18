import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/theme/theme.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Blogify extends StatefulWidget {
  const Blogify({super.key});

  @override
  State<Blogify> createState() => _BlogifyState();
}

class _BlogifyState extends State<Blogify> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthBloc>().add(IsUserLoggedInEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AuthBloc>().add(IsUserLoggedInEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, appUserState) {
        print("AppUserState: $appUserState");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
         theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system, 
          title: 'Blogify',
          home: _getInitialPage(appUserState),
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }

  Widget _getInitialPage(AppUserState state) {
    if (state is AppUserLoggedIn) {
      print("Navigating to HomePage");
      return const Scaffold(
        body: Center(child: Text('Home Page')),
      );
     } else {
      print("Navigating to LoginPage");
      return const LoginPage();
    }
  }
}
