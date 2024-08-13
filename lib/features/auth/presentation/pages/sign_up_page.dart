import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogify/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.3,
            horizontal: MediaQuery.of(context).size.width * 0.04),
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
            const AuthField(
              hintText: 'Name',
            ),
            const SizedBox(height: 15),
            const AuthField(
              hintText: 'Email',
            ),
            const SizedBox(height: 15),
            const AuthField(
              hintText: 'Password',
              isObscureText: true,
            ),
            const SizedBox(height: 20),
            AuthGradientButton(buttonText: 'Sign Up', onPressed: () {}),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: 'Sign In',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppPallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
