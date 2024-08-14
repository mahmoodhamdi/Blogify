import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/core/validators/validation.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.3,
            horizontal: MediaQuery.of(context).size.width * 0.04),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  validator: (value) {
                    return FieldValidator.validateName(value);
                  }),
              const SizedBox(height: 15),
              AuthField(
                  hintText: 'Email',
                  controller: emailController,
                  validator: (value) {
                    return FieldValidator.validateEmail(value);
                  }),
              const SizedBox(height: 15),
              AuthField(
                  hintText: 'Password',
                  controller: passwordController,
                  isObscureText: true,
                  validator: (value) {
                    return FieldValidator.validatePassword(value);
                  }),
              const SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacementNamed(context, Routes.loginInPage);
                  } else if (state is AuthError) {
                    showSnackBar(content: state.message, context: context);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Loading();
                  } else {
                    return AuthGradientButton(
                        buttonText: 'Sign Up',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        });
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.loginInPage);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
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
    );
  }
}
