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
import 'package:blogify/features/blog/presentation/widgets/rich_text_editor.dart';
import 'package:blogify/features/comments/presentation/bloc/comment_bloc.dart';
import 'package:blogify/features/comments/presentation/widgets/comments_section.dart';
import 'package:blogify/init_dependencies.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:share_plus/share_plus.dart';

class BlogViewPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route(Blog blog, Color cardColor) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<CommentBloc>(),
          child: BlogViewPage(
            blog: blog,
            cardColor: cardColor,
          ),
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
  late QuillController _contentController;
  double _scrollOffset = 0;
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.blog.isLiked;
    _isBookmarked = widget.blog.isBookmarked;
    _likesCount = widget.blog.likesCount;
    _contentController = RichTextHelper.createController(widget.blog.content);
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
    _contentController.dispose();
    super.dispose();
  }

  String? _getCurrentUserId() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      return appUserState.user.id;
    }
    return null;
  }

  void _toggleLike() {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    context.read<BlogBloc>().add(
          BlogToggleLike(
            blogId: widget.blog.id,
            userId: userId,
          ),
        );
  }

  void _toggleBookmark() {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    context.read<BlogBloc>().add(
          BlogToggleBookmark(
            blogId: widget.blog.id,
            userId: userId,
          ),
        );
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
        } else if (state is BlogLikeToggled) {
          if (state.blog.id == widget.blog.id) {
            setState(() {
              _isLiked = state.blog.isLiked;
              _likesCount = state.blog.likesCount;
            });
          }
        } else if (state is BlogBookmarkToggled) {
          if (state.blog.id == widget.blog.id) {
            setState(() {
              _isBookmarked = state.blog.isBookmarked;
            });
            showSnackBar(
              content: _isBookmarked
                  ? 'Blog added to bookmarks'
                  : 'Blog removed from bookmarks',
              context: context,
              type: SnackBarType.success,
            );
          }
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
              actions: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : null,
                  ),
                  tooltip: _isLiked ? 'Unlike' : 'Like',
                ),
                IconButton(
                  onPressed: _toggleBookmark,
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: _isBookmarked ? accentColor : null,
                  ),
                  tooltip: _isBookmarked ? 'Remove Bookmark' : 'Bookmark',
                ),
                if (isOwner) ...[
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
                ],
              ],
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
                  const SizedBox(height: 12),

                  // Likes row
                  Row(
                    children: [
                      InkWell(
                        onTap: _toggleLike,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked ? Colors.red : textColor,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likesCount ${_likesCount == 1 ? 'like' : 'likes'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: _toggleBookmark,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: _isBookmarked ? accentColor : textColor,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isBookmarked ? 'Bookmarked' : 'Bookmark',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Blog Content (Rich Text)
                  QuillEditor.basic(
                    controller: _contentController,
                    config: QuillEditorConfig(
                      showCursor: false,
                      autoFocus: false,
                      padding: EdgeInsets.zero,
                      customStyles: DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                          TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: textColor,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(8, 8),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        h1: DefaultTextBlockStyle(
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(16, 8),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        h2: DefaultTextBlockStyle(
                          TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(14, 6),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        h3: DefaultTextBlockStyle(
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(12, 4),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        code: DefaultTextBlockStyle(
                          TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.green.shade300
                                : Colors.green.shade700,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(4, 4),
                          const VerticalSpacing(0, 0),
                          BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        quote: DefaultTextBlockStyle(
                          TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                            color: textColor.withValues(alpha: 0.8),
                          ),
                          const HorizontalSpacing(16, 0),
                          const VerticalSpacing(8, 8),
                          const VerticalSpacing(0, 0),
                          BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: accentColor,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                        link: TextStyle(
                          color: accentColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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

          // Comments Section
          SliverToBoxAdapter(
            child: CommentsSection(blogId: widget.blog.id),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
        ),
      ),
    );
  }
}
