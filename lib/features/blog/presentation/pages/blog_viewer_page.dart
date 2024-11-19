import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/calculate_reading_time.dart';
import 'package:blogify/core/utils/format_date.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatefulWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewPage(
          blog: blog,
        ),
      );
  final Blog blog;

  const BlogViewPage({
    super.key,
    required this.blog,
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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Collapsible AppBar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
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
            backgroundColor:
                isDarkMode ? AppPalette.darkPrimary : AppPalette.lightPrimary,
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
                        'By ${widget.blog.posterName}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${formatDateBydMMMYYYY(widget.blog.updatedAt)} • ${calculateReadingTime(widget.blog.content)} min read',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textColor.withOpacity(0.6),
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
                        onPressed: () {
                          // Handle action
                        },
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
    );
  }
}
