import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/auth/presentation/pages/sign_up_page.dart';
import 'package:blogify/features/blog/presentation/pages/add_blog_page.dart';
import 'package:blogify/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String signInPage = '/sign_in_page';
  static const String signUpPage = '/sign_up_page';
  static const String blogPage = '/blog_page';
  static const String addBlogPage = '/add_blog_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signInPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case signUpPage:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
        );
      case blogPage:
        return MaterialPageRoute(
          builder: (_) => const BlogPage(),
        );
        case addBlogPage:
        return MaterialPageRoute(
          builder: (_) => const AddBlogPage(),
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
