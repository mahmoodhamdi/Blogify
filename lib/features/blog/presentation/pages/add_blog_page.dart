import 'dart:io';

import 'package:blogify/core/common/widgets/choice_chip_widget.dart';
import 'package:blogify/core/common/widgets/gradient_button.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/pick_image.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _uploadBlog(context);
                },
                icon: const Icon(Icons.done_rounded)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  image != null
                      ? GestureDetector(
                          onTap: selectImage,
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: DottedBorder(
                            color: AppPallete.borderColor,
                            dashPattern: const [10, 4],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  ChoiceChipWidget(
                    onSelectionChanged: (List<String> topics) {
                      setState(() {
                        selectedTopics = topics;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  BlogEditor(
                    controller: titleController,
                    hintText: 'Blog title',
                  ),
                  const SizedBox(height: 10),
                  BlogEditor(
                    controller: contentController,
                    hintText: 'Blog content',
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<BlogBloc, BlogState>(
                    listener: (context, state) {
                      if (state is BlogAdded) {
                        Navigator.pushReplacementNamed(
                            context, Routes.blogPage);
                      }
                      if (state is BlogFailure) {
                        showSnackBar(
                            context: context, content: state.failure.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is BlogLoading) {
                        return const Loader();
                      }
                      return GradientButton(
                          buttonText: 'Add Blog',
                          onPressed: () {
                            _uploadBlog(context);
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _uploadBlog(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final String posterId =
          (context.read<AuthBloc>().state as AuthSuccess).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              image: image,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              posterId: posterId,
              topics: selectedTopics,
            ),
          );

      Navigator.pushReplacementNamed(context, Routes.blogPage);
    }
  }
}
