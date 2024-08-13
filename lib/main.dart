import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      title: 'Blogify',
      initialRoute: Routes.loginInPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
