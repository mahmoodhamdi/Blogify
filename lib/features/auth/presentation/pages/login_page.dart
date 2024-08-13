import 'package:blogify/core/routes/routes.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/validators/validation.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                'Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
              AuthGradientButton(
                  buttonText: 'Sign In',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print("Email: ${emailController.text.trim()}\n");
                      print("Password: ${passwordController.text.trim()}\n");
                      print('Form is valid');
                    }
                  }),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.signUpPage);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
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
