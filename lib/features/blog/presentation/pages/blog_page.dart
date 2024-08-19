import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(const GetAllBlogsEvent());
  }

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
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(
                context: context,
                content: state.failure.message,
                type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          } else if (state is BlogsListLoaded) {
            return ListView.builder(
              itemCount: state.blogList.length,
              itemBuilder: (context, index) {
                return BlogCard(
                  blog: state.blogList[index],
                  index: index,
                );
              },
            );
          } else {
            return const Text('There Are No Blogs');
          }
        },
      ),
    );
  }
}
