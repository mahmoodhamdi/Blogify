import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/calculate_reading_time.dart';
import 'package:blogify/core/utils/format_date.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/pages/blog_page.dart';
import 'package:blogify/features/blog/presentation/pages/edit_blog_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class BlogViewPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route(Blog blog, Color cardColor) => MaterialPageRoute(
        builder: (context) => BlogViewPage(
          blog: blog,
          cardColor: cardColor,
        ),
      );
  final Blog blog;
  final Color cardColor;

  const BlogViewPage({
    super.key,
    required this.blog,
    required this.cardColor,
  });

  @override
  State<BlogViewPage> createState() => _BlogViewPageState();
}

class _BlogViewPageState extends State<BlogViewPage> {
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _shareBlog() {
    final blog = widget.blog;
    final shareText = '''
${blog.title}

${blog.content.length > 200 ? '${blog.content.substring(0, 200)}...' : blog.content}

By ${blog.posterName ?? 'Anonymous'}
Read more on Blogify!
''';
    Share.share(shareText, subject: blog.title);
  }

  bool _isOwner(BuildContext context) {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      return appUserState.user.id == widget.blog.posterId;
    }
    return false;
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Blog'),
        content: const Text(
          'Are you sure you want to delete this blog? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BlogBloc>().add(BlogDelete(blogId: widget.blog.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppPalette.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground;
    final textColor = isDarkMode ? AppPalette.darkText : AppPalette.lightText;
    final accentColor =
        isDarkMode ? AppPalette.darkAccent : AppPalette.lightAccent;

    // Title animation opacity (fades out as you scroll up)
    final titleOpacity = (_scrollOffset < 100) ? 1 - (_scrollOffset / 100) : 0;
    final isOwner = _isOwner(context);

    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleteSuccess) {
          showSnackBar(
            content: 'Blog deleted successfully',
            context: context,
            type: SnackBarType.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
        } else if (state is BlogFailure) {
          showSnackBar(
            content: state.error,
            context: context,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Collapsible AppBar
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              actions: isOwner
                  ? [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            EditBlogPage.route(widget.blog),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Blog',
                      ),
                      IconButton(
                        onPressed: _showDeleteDialog,
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete Blog',
                      ),
                    ]
                  : null,
              flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: titleOpacity < 0.3 ? 1 : 0,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.blog.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.blog.imageUrl,
                placeholder: (context, url) => const Loader(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fadeInDuration: const Duration(milliseconds: 300),
                fit: BoxFit.cover,
              ),
            ),
            backgroundColor: widget.cardColor,
          ),
          // Content Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with fade-in animation
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: titleOpacity.toDouble(),
                    child: Text(
                      widget.blog.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Poster Name & Meta Info
                  Row(
                    children: [
                      Text(
                        'By ${widget.blog.posterName ?? 'Anonymous'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${formatDateBydMMMYYYY(widget.blog.updatedAt)} • ${calculateReadingTime(widget.blog.content)} min read',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Blog Content
                  Text(
                    widget.blog.content,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // CTA Button with fade-in effect
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _scrollOffset > 100 ? 1 : 0.5,
                      child: ElevatedButton(
                        onPressed: () => _shareBlog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Share this Blog',
                          style: TextStyle(
                            fontSize: 16,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
