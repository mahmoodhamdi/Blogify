import 'package:blogify/blogify_app.dart';
import 'package:blogify/core/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

  runApp(
    const BlogifyApp(),
  );
}
