import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/service_locator/service_locator.dart';
import 'package:blogify/core/theme/theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

  runApp(
    const MyApp(),
  );
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
      initialRoute: Routes.signUpPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
