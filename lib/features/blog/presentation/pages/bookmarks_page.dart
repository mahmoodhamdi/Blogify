import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const BookmarksPage(),
      );

  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBookmarks();
    _scrollController.addListener(_onScroll);
  }

  String? _getCurrentUserId() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      return appUserState.user.id;
    }
    return null;
  }

  void _fetchBookmarks() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      context.read<BlogBloc>().add(BlogFetchBookmarks(userId: userId));
    }
  }

  void _onScroll() {
    if (_isBottom) {
      final userId = _getCurrentUserId();
      if (userId != null) {
        context.read<BlogBloc>().add(BlogFetchMoreBookmarks(userId: userId));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: Loader());
          }

          if (state is BlogFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppPalette.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchBookmarks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BlogBookmarksDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 60,
                      color: isDarkMode
                          ? AppPalette.darkText.withValues(alpha: 0.5)
                          : AppPalette.lightText.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No bookmarks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode
                            ? AppPalette.darkText.withValues(alpha: 0.7)
                            : AppPalette.lightText.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bookmark blogs to read them later!',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppPalette.darkText.withValues(alpha: 0.5)
                            : AppPalette.lightText.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _fetchBookmarks();
                await context.read<BlogBloc>().stream.firstWhere(
                      (state) =>
                          state is BlogBookmarksDisplaySuccess ||
                          state is BlogFailure,
                    );
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.blogs.length
                    : state.blogs.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.blogs.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return BlogCard(
                    index: index,
                    blog: state.blogs[index],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
