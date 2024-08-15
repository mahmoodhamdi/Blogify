import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String homePage = '/home_page';
  static const String signInPage = '/sign_in_page';
  static const String signUpPage = '/sign_up_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: const Center(child: Text('Welcome to the Home Page!')),
          ), // Replace with your actual HomePage widget
        );
      case signInPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case signUpPage:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('${settings.name} not found')),
            appBar: AppBar(title: const Text('Error')),
          ),
        );
    }
  }
}
