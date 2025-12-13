import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/cubits/theme/theme_cubit.dart';
import 'package:blogify/core/common/cubits/theme/theme_state.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogify/features/auth/presentation/pages/login_page.dart';
import 'package:blogify/features/blog/presentation/widgets/blog_card.dart';
import 'package:blogify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:blogify/features/profile/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      );

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUserBlogs();
    _scrollController.addListener(_onScroll);
  }

  void _fetchUserBlogs() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(
            ProfileFetchUserBlogs(userId: appUserState.user.id),
          );
    }
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProfileBloc>().add(ProfileFetchMoreBlogs());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildThemeSelector(BuildContext context, bool isDarkMode) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final themeCubit = context.read<ThemeCubit>();
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppPalette.darkSurface : AppPalette.lightSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              themeCubit.themeModeIcon,
              color: isDarkMode ? AppPalette.darkPrimary : AppPalette.lightPrimary,
            ),
            title: Text(
              'Theme',
              style: TextStyle(
                color: isDarkMode ? AppPalette.darkText : AppPalette.lightText,
              ),
            ),
            subtitle: Text(
              themeCubit.themeModeLabel,
              style: TextStyle(
                color: isDarkMode
                    ? AppPalette.darkText.withValues(alpha: 0.7)
                    : AppPalette.lightText.withValues(alpha: 0.7),
              ),
            ),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode, size: 18),
                ),
              ],
              selected: {themeState.themeMode},
              onSelectionChanged: (Set<ThemeMode> selected) {
                themeCubit.setThemeMode(selected.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          showSnackBar(
            content: state.message,
            context: context,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, appUserState) {
            if (appUserState is! AppUserLoggedIn) {
              return const Center(child: Text('Not logged in'));
            }

            final user = appUserState.user;

            return RefreshIndicator(
              onRefresh: () async {
                _fetchUserBlogs();
                await context.read<ProfileBloc>().stream.firstWhere(
                      (state) =>
                          state is ProfileLoaded || state is ProfileFailure,
                    );
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Profile Header
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      name: user.name,
                      email: user.email,
                      isDarkMode: isDarkMode,
                    ),
                  ),

                  // Settings Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? AppPalette.darkText
                                  : AppPalette.lightText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildThemeSelector(context, isDarkMode),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Section Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'My Blogs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppPalette.darkText
                              : AppPalette.lightText,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),

                  // Blogs List
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const SliverFillRemaining(
                          child: Center(child: Loader()),
                        );
                      }

                      if (state is ProfileFailure) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: AppPalette.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchUserBlogs,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is ProfileLoaded) {
                        if (state.blogs.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 60,
                                    color: isDarkMode
                                        ? AppPalette.darkText
                                            .withValues(alpha: 0.5)
                                        : AppPalette.lightText
                                            .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No blogs yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDarkMode
                                          ? AppPalette.darkText
                                              .withValues(alpha: 0.7)
                                          : AppPalette.lightText
                                              .withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start writing your first blog!',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? AppPalette.darkText
                                              .withValues(alpha: 0.5)
                                          : AppPalette.lightText
                                              .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= state.blogs.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return BlogCard(
                                index: index,
                                blog: state.blogs[index],
                              );
                            },
                            childCount: state.hasReachedMax
                                ? state.blogs.length
                                : state.blogs.length + 1,
                          ),
                        );
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
