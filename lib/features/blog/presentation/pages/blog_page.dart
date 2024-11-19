import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());

    // FAB Animation
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final colorPalette = isDarkTheme
        ? BlogColorPaletteDark.colors
        : BlogColorPaletteLight.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogify'),
        actions: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _fabController,
              curve: Curves.easeInOut,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(
              content: state.error,
              context: context,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                final backgroundColor =
                    colorPalette[index % colorPalette.length];

                return AnimatedBuilder(
                  animation: _fabController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fabController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _fabController,
                          curve: Curves.easeOut,
                        )),
                        child: BlogCard(
                          index: index,
                          blog: blog,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Blogs Found',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                        fontSize: 18,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
