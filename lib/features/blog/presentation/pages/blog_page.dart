import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_card.dart';
import 'package:blogify/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBlogs();

    // FAB Animation
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    // Infinite scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BlogBloc>().add(BlogFetchMoreBlogs());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load more when 90% scrolled
  }

  void _fetchBlogs() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  Future<void> _onRefresh() async {
    context.read<BlogBloc>().add(BlogFetchAllBlogs(refresh: true));
    // Wait for the state to change
    await context.read<BlogBloc>().stream.firstWhere(
          (state) => state is BlogsDisplaySuccess || state is BlogFailure,
        );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                tooltip: 'New Blog',
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, ProfilePage.route());
              },
              icon: const Icon(Icons.person),
              tooltip: 'Profile',
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
            if (state.blogs.isEmpty) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _buildEmptyState(),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.hasReachedMax
                    ? state.blogs.length
                    : state.blogs.length + 1,
                itemBuilder: (context, index) {
                  // Show loading indicator at the bottom
                  if (index >= state.blogs.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final blog = state.blogs[index];

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
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildEmptyState(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Blogs Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or tap + to create a blog',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
        ],
      ),
    );
  }
}
