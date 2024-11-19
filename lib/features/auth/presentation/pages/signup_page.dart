import 'package:blogify/core/common/widgets/gradient_button.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/hide_keyboard.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogify/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.3,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        showSnackBar(
                            content: state.message,
                            context: context,
                            type: SnackBarType.error);
                      } else if (state is AuthSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          BlogPage.route(),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Loader();
                      }

                      return GradientButton(
                        buttonText: 'Sign Up',
                        onPressed: () {
                         hideKeyboard();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppPalette.darkAccent
                                      : AppPalette.lightAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
