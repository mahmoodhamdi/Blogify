import 'dart:io';

import 'package:blogify/core/common/widgets/gradient_button.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/pick_image.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/blog/domain/entities/blog.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/pages/blog_page.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route(Blog blog) => MaterialPageRoute(
        builder: (context) => EditBlogPage(blog: blog),
      );

  final Blog blog;

  const EditBlogPage({super.key, required this.blog});

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? newImage;
  bool imageChanged = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with existing blog data
    titleController.text = widget.blog.title;
    contentController.text = widget.blog.content;
    selectedTopics = List<String>.from(widget.blog.topics);
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        newImage = pickedImage;
        imageChanged = true;
      });
    }
  }

  void updateBlog() {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      context.read<BlogBloc>().add(
            BlogUpdate(
              blogId: widget.blog.id,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: imageChanged ? newImage : null,
              topics: selectedTopics,
            ),
          );
    } else if (selectedTopics.isEmpty) {
      showSnackBar(
        content: 'Please select at least one topic',
        context: context,
        type: SnackBarType.warning,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog'),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(
              content: state.error,
              context: context,
              type: SnackBarType.error,
            );
          } else if (state is BlogUpdateSuccess) {
            showSnackBar(
              content: 'Blog updated successfully',
              context: context,
              type: SnackBarType.success,
            );
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Image Section
                  GestureDetector(
                    onTap: selectImage,
                    child: imageChanged && newImage != null
                        ? SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                newImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget.blog.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Loader(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Tap to change image',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Topics Selection
                  _buildTopicsSelection(isDarkMode),
                  const SizedBox(height: 10),

                  // Title Editor
                  BlogEditor(
                    controller: titleController,
                    hintText: 'Blog title',
                  ),
                  const SizedBox(height: 10),

                  // Content Editor
                  BlogEditor(
                    controller: contentController,
                    hintText: 'Blog content',
                  ),
                  const SizedBox(height: 20),

                  // Update Button
                  GradientButton(
                    buttonText: 'Update Blog',
                    onPressed: updateBlog,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicsSelection(bool isDarkMode) {
    const topics = [
      'Technology',
      'Business',
      'Programming',
      'Entertainment',
      'Health',
      'Travel',
      'Food',
      'Sports',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Topics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppPalette.darkText : AppPalette.lightText,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.map((topic) {
            final isSelected = selectedTopics.contains(topic);
            return FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTopics.add(topic);
                  } else {
                    selectedTopics.remove(topic);
                  }
                });
              },
              selectedColor: isDarkMode
                  ? AppPalette.darkAccent.withValues(alpha: 0.3)
                  : AppPalette.lightAccent.withValues(alpha: 0.3),
              checkmarkColor:
                  isDarkMode ? AppPalette.darkAccent : AppPalette.lightAccent,
            );
          }).toList(),
        ),
      ],
    );
  }
}
