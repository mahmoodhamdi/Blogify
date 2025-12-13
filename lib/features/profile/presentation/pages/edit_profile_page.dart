import 'dart:io';

import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/core/theme/app_pallete.dart';
import 'package:blogify/core/utils/pick_image.dart';
import 'package:blogify/core/utils/show_snackbar.dart';
import 'package:blogify/core/validators/validation.dart';
import 'package:blogify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      );

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _avatarImage;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      _currentUser = appUserState.user;
      _nameController.text = _currentUser.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        _avatarImage = pickedImage;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            ProfileUpdateRequested(
              userId: _currentUser.id,
              name: _nameController.text.trim(),
              avatarImage: _avatarImage,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileUpdating) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check),
                tooltip: 'Save',
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            // Update the AppUserCubit with the new user data
            context.read<AppUserCubit>().updateUser(state.user);
            showSnackBar(
              content: 'Profile updated successfully!',
              context: context,
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          } else if (state is ProfileFailure) {
            showSnackBar(
              content: state.message,
              context: context,
              type: SnackBarType.error,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar
                _buildAvatarSection(isDarkMode),
                const SizedBox(height: 32),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => FieldValidator.validateName(value),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveProfile(),
                ),
                const SizedBox(height: 16),

                // Email field (read-only)
                TextFormField(
                  initialValue: _currentUser.email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: isDarkMode
                        ? AppPalette.darkSurface.withValues(alpha: 0.5)
                        : AppPalette.lightSurface.withValues(alpha: 0.5),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                Text(
                  'Email cannot be changed',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppPalette.darkText.withValues(alpha: 0.5)
                        : AppPalette.lightText.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool isDarkMode) {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: isDarkMode
                    ? AppPalette.darkPrimary.withValues(alpha: 0.2)
                    : AppPalette.lightPrimary.withValues(alpha: 0.2),
                backgroundImage: _getAvatarImage(),
                child: _avatarImage == null && _currentUser.avatarUrl == null
                    ? Text(
                        _getInitials(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppPalette.darkPrimary
                              : AppPalette.lightPrimary,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppPalette.darkPrimary
                        : AppPalette.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: isDarkMode
                        ? AppPalette.darkText
                        : AppPalette.lightSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to change photo',
          style: TextStyle(
            color: isDarkMode
                ? AppPalette.darkText.withValues(alpha: 0.7)
                : AppPalette.lightText.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getAvatarImage() {
    if (_avatarImage != null) {
      return FileImage(_avatarImage!);
    }
    if (_currentUser.avatarUrl != null && _currentUser.avatarUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(_currentUser.avatarUrl!);
    }
    return null;
  }

  String _getInitials() {
    final nameParts = _currentUser.name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return _currentUser.name.isNotEmpty
        ? _currentUser.name[0].toUpperCase()
        : '?';
  }
}
