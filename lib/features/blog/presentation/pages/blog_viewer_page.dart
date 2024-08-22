import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/calculate_reading_time.dart';
import 'package:blogify/core/utils/format_date.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          blog.title,
          style: TextStyle(
            color: isDarkMode ? AppPalette.darkText : AppPalette.lightText,
          ),
        ),
        backgroundColor:
            isDarkMode ? AppPalette.darkPrimary : AppPalette.lightPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode ? AppPalette.darkText : AppPalette.lightText,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'By ${blog.posterName}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppPalette.darkText.withOpacity(0.7)
                      : AppPalette.lightText.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 5),
              // You can uncomment and adjust the following block if needed
              Text(
                '${formatDateBydMMMYYYY(blog.updatedAt)}. ${calculateReadingTime(blog.content)} min',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppPalette.darkText.withOpacity(0.6)
                      : AppPalette.lightText.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: blog.imageUrl,
                    placeholder: (context, url) => const Loader(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                blog.content,
                style: TextStyle(
                  fontSize: 16,
                  height: 2,
                  color:
                      isDarkMode ? AppPalette.darkText : AppPalette.lightText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
