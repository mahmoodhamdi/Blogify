import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String homePage = '/home_Page';
  static const String loginInPage = '/login_Page';
  static const String signUpPage = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // this arguments is for passing data from one screen to another
    // final arguments = settings.arguments;

    switch (settings.name) {
      case loginInPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case signUpPage:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
        );
      default:
        // error page
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('${settings.name} not found')),
                  appBar: AppBar(title: const Text('Error')),
                ));
    }
  }
}
