import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogifySplashScreen extends StatefulWidget {
  const BlogifySplashScreen({super.key});

  @override
  _BlogifySplashScreenState createState() => _BlogifySplashScreenState();
}

class _BlogifySplashScreenState extends State<BlogifySplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _textOpacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Trigger auth check
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..forward();

    _initializeAnimations();
  }

  void _initializeAnimations() {
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateAfterDelay(Widget page) {
    Future.delayed(const Duration(seconds: 4), () {
      // Ensure navigation happens only if the splash screen is still active
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => page),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _navigateAfterDelay(const BlogPage());
        } else if (state is AuthFailure) {
          _navigateAfterDelay(const LoginPage());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Brand Name
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: Text(
                    'Blogify',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 3.0,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Animated Tagline
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: Text(
                  'Unleash Your Creative Voice',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              // Loading Indicator
              FadeTransition(opacity: _textOpacityAnimation, child: Loader()),
            ],
          ),
        ),
      ),
    );
  }
}
