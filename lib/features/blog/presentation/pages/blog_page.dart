import 'dart:async';

import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/constants/constants.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  bool _isSearching = false;
  final List<String> _selectedTopics = [];

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
      final state = context.read<BlogBloc>().state;
      if (state is BlogSearchSuccess) {
        context.read<BlogBloc>().add(BlogSearchMoreResults());
      } else {
        context.read<BlogBloc>().add(BlogFetchMoreBlogs());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _fetchBlogs() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty && _selectedTopics.isEmpty) {
        context.read<BlogBloc>().add(BlogClearSearch());
      } else {
        context.read<BlogBloc>().add(BlogSearch(
              query: query,
              topics: _selectedTopics.isEmpty ? null : _selectedTopics,
            ));
      }
    });
  }

  void _toggleTopic(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
    _onSearchChanged(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _selectedTopics.clear();
      _isSearching = false;
    });
    context.read<BlogBloc>().add(BlogClearSearch());
  }

  Future<void> _onRefresh() async {
    final state = context.read<BlogBloc>().state;
    if (state is BlogSearchSuccess) {
      context.read<BlogBloc>().add(BlogSearch(
            query: state.query,
            topics: state.topics,
          ));
    } else {
      context.read<BlogBloc>().add(BlogFetchAllBlogs(refresh: true));
    }
    await context.read<BlogBloc>().stream.firstWhere(
          (state) =>
              state is BlogsDisplaySuccess ||
              state is BlogSearchSuccess ||
              state is BlogFailure,
        );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildDefaultAppBar(),
      body: Column(
        children: [
          if (_isSearching) _buildTopicFilters(),
          Expanded(
            child: BlocConsumer<BlogBloc, BlogState>(
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

                if (state is BlogSearchSuccess) {
                  return _buildBlogList(
                    blogs: state.blogs,
                    hasReachedMax: state.hasReachedMax,
                    isSearchResult: true,
                    query: state.query,
                  );
                }

                if (state is BlogsDisplaySuccess) {
                  return _buildBlogList(
                    blogs: state.blogs,
                    hasReachedMax: state.hasReachedMax,
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
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      title: const Text('Blogify'),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
          icon: const Icon(Icons.search),
          tooltip: 'Search',
        ),
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
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _clearSearch,
        icon: const Icon(Icons.arrow_back),
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search blogs...',
          border: InputBorder.none,
        ),
        onChanged: _onSearchChanged,
      ),
      actions: [
        if (_searchController.text.isNotEmpty || _selectedTopics.isNotEmpty)
          IconButton(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
      ],
    );
  }

  Widget _buildTopicFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: Constants.topics.map((topic) {
            final isSelected = _selectedTopics.contains(topic);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (_) => _toggleTopic(topic),
                selectedColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBlogList({
    required List<Blog> blogs,
    required bool hasReachedMax,
    bool isSearchResult = false,
    String? query,
  }) {
    if (blogs.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _buildEmptyState(
                isSearchResult: isSearchResult,
                query: query,
              ),
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
        itemCount: hasReachedMax ? blogs.length : blogs.length + 1,
        itemBuilder: (context, index) {
          if (index >= blogs.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final blog = blogs[index];

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

  Widget _buildEmptyState({bool isSearchResult = false, String? query}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearchResult ? Icons.search_off : Icons.article_outlined,
            size: 80,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isSearchResult ? 'No Results Found' : 'No Blogs Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchResult
                ? 'Try a different search term or topic'
                : 'Pull down to refresh or tap + to create a blog',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
            textAlign: TextAlign.center,
          ),
          if (isSearchResult) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }
}
