import 'package:blogify/core/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogify'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.addBlogPage);
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
    );
  }
}
