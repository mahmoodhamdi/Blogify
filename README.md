# Blogify

[![wakatime](https://wakatime.com/badge/user/018c9017-daf8-45c1-be71-8b16fd238022/project/0a155339-8a16-4ffb-a6db-0e2f32481c0f.svg)](https://wakatime.com/badge/user/018c9017-daf8-45c1-be71-8b16fd238022/project/0a155339-8a16-4ffb-a6db-0e2f32481c0f)

**Blogify** is a modern, feature-rich blogging platform built with Flutter and Supabase. It provides a seamless and visually appealing experience for users to create, edit, and manage blogs. Designed with clean architecture, Blogify ensures a scalable, maintainable, and testable codebase, making it ideal for developers and contributors who value high-quality standards.

---

## Table of Contents

- [Blogify](#blogify)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Key Features](#key-features)
  - [Project Structure](#project-structure)
  - [Supabase Backend Structure](#supabase-backend-structure)
    - [Overview](#overview)
    - [Database Schema](#database-schema)
    - [Database Tables and Policies](#database-tables-and-policies)
      - [1. Profiles Table](#1-profiles-table)
      - [2. Blogs Table](#2-blogs-table)
      - [3. Storage for Blog Images](#3-storage-for-blog-images)
    - [Automatic Profile Creation on User Signup](#automatic-profile-creation-on-user-signup)
    - [Contributions and Further Information](#contributions-and-further-information)
  - [Installation](#installation)
  - [Contributing](#contributing)

---

## Features

- [x] **Authentication**
  - [x] Sign Up
  - [x] Sign In
  - [x] Current User Session Management

- [x] **Blog Management**
  - [x] Create New Blogs
  - [ ] Edit Blogs
  - [ ] Delete Blogs
  - [x] View All Blogs

- [x] **User Interface**
  - [x] Professional and modern UI with dark theme support
  - [x] Responsive design for mobile devices

- [x] **Utilities**
  - [x] Image Picker for blog cover images
  - [x] Snackbar Notifications
  - [x] Date Formatting and Reading Time Calculation

- [ ] **Advanced Blog Search**
  - [ ] Implement advanced search capabilities with filters like tags, categories, and publication date.

- [ ] **User Profiles**
  - [ ] Allow users to create and customize their profiles, displaying their published blogs and bio.

- [ ] **Comment System**
  - [ ] Enable users to leave comments on blogs and engage in discussions.

- [ ] **Blog Analytics**
  - [ ] Provide blog authors with insights into views, reading time, and audience engagement.

- [ ] **Social Sharing**
  - [ ] Integrate social media sharing options for blogs.

- [ ] **Notifications**
  - [ ] Implement push notifications for new blogs, comments, and updates.

- [ ] **Drafts**
  - [ ] Allow users to save blogs as drafts before publishing.

- [ ] **Markdown Support**
  - [ ] Enable blog creation and editing using Markdown for formatting.
- [ ] **CI/CD**
  - [ ] **GitHub Actions**: Automated workflows for building, testing, and deploying the app.
  - [ ] **Fastlane Integration**: Streamlined build and release processes using Fastlane.
  - [ ] **Firebase App Distribution**: Automatic distribution of the app to testers via Firebase.

- [ ] **GitHub Releases**
  - [ ] Automatically create GitHub releases with versioned changelogs.

---

## Key Features

- **Flutter & Supabase Integration**
  - **Frontend with Flutter**: Delivers a responsive and visually appealing user interface.
  - **Backend with Supabase**: Facilitates seamless authentication, database management, and storage.
  
- **Clean Architecture**
  - **Layered Structure**: Ensures better organization and scalability with distinct layers.
  - **Separation of Concerns**: Promotes maintainability and testability by assigning specific responsibilities to each layer.

- **BLoC Pattern**
  - **State Management**: Manages complex state and business logic using flutter_bloc.
  - **Event-Driven**: Reacts to app events by dispatching actions that modify the state.

- **Responsive UI**
  - **Mobile Optimization**: Provides a smooth experience on various screen sizes.
  - **Dark Theme Support**: Includes a professional and modern dark theme.

- **Image Management**
  - **Image Picker Integration**: Allows users to select and upload blog cover images.
  - **Visual Appeal**: Supports blog cover images for enriching each post.

- **Secure User Authentication**
  - **Sign Up & Login**: Provides secure authentication features.
  - **Session Management**: Efficiently manages user sessions for a smooth experience.

---

## Project Structure

Detailed visualization of the project structure:

```markdown
Blogify
├── lib
│   ├── core
│   │   ├── common
│   │   │   ├── cubits
│   │   │   │   └── app_user
│   │   │   │       └── app_user_state.dart
│   │   │   ├── entities
│   │   │   │   └── user.dart
│   │   │   ├── widgets
│   │   │   │   ├── choice_chip_widget.dart
│   │   │   │   ├── gradient_button.dart
│   │   │   │   └── loader.dart
│   │   ├── constants
│   │   │   └── constants.dart
│   │   ├── error
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network
│   │   │   └── connection_checker.dart
│   │   ├── secrets
│   │   │   └── app_secrets.dart
│   │   ├── theme
│   │   │   ├── app_pallete.dart
│   │   │   └── theme.dart
│   │   ├── usecase
│   │   │   └── usecase.dart
│   │   ├── utils
│   │   │   ├── show_snackbar.dart
│   │   │   ├── pick_image.dart
│   │   │   ├── format_date.dart
│   │   │   └── calculate_reading_time.dart
│   │   └── validators
│   │       └── validation.dart
│   ├── features
│   │   ├── auth
│   │   │   ├── data
│   │   │   │   ├── datasources
│   │   │   │   │   └── auth_remote_data_source.dart
│   │   │   │   ├── models
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain
│   │   │   │   ├── repository
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   ├── usecases
│   │   │   │   │   ├── current_user.dart
│   │   │   │   │   ├── user_login.dart
│   │   │   │   │   └── user_sign_up.dart
│   │   │   └── presentation
│   │   │       ├── bloc
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages
│   │   │       │   ├── login_page.dart
│   │   │       │   └── signup_page.dart
│   │   │       └── widgets
│   │   │           └── auth_field.dart
│   │   ├── blog
│   │   │   ├── data
│   │   │   │   ├── datasources
│   │   │   │   │   └── blog_remote_data_source.dart
│   │   │   │   ├── models
│   │   │   │   │   └── blog_model.dart
│   │   │   │   └── repositories
│   │   │   │       └── blog_repository_impl.dart
│   │   │   ├── domain
│   │   │   │   ├── entities
│   │   │   │   │   └── blog.dart
│   │   │   │   ├── repositories
│   │   │   │   │   └── blog_repository.dart
│   │   │   │   ├── usecases
│   │   │   │   │   ├── get_all_blogs.dart
│   │   │   │   │   └── upload_blog.dart
│   │   │   └── presentation
│   │   │       ├── bloc
│   │   │       │   ├── blog_bloc.dart
│   │   │       │   ├── blog_event.dart
│   │   │       │   └── blog_state.dart
│   │   │       ├── pages
│   │   │       │   ├── add_new_blog_page.dart
│   │   │       │   ├── blog_page.dart
│   │   │       │   ├── blog_viewer_page.dart
│   │   │       └── widgets
│   │   │           ├── blog_card.dart
│   │   │           └── blog_editor.dart
│   ├── init_dependencies.dart
│   ├── init_dependencies.main.dart
│   └── main.dart
```

---

## Supabase Backend Structure

### Overview

Blogify uses Supabase as its backend, providing seamless authentication, database management, and storage functionalities. Below is an outline of the key database tables, policies, and SQL queries implemented in the project.

### Database Schema

![Capture](https://github.com/user-attachments/assets/d9578a3e-2048-4689-b2b0-7b4d3bfb3227)

### Database Tables and Policies

#### 1. Profiles Table

The `profiles` table stores user profile information.

```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE,
  name TEXT,
  
  CONSTRAINT name_length CHECK (char_length(name) >= 3)
);

-- Enable Row Level Security (RLS) on the profiles table
ALTER TABLE profiles
  ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Public profiles are viewable by everyone." ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON profiles
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update their own profile." ON profiles
  FOR UPDATE USING ((SELECT auth.uid()) = id);
```

#### 2. Blogs Table

The `blogs` table stores the blog posts created by users.

```sql
-- Enable Row Level Security (RLS) on the blogs table
ALTER TABLE blogs
  ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Public blogs are viewable by everyone." ON blogs
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own blogs." ON blogs
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update their own blogs." ON blogs
  FOR UPDATE USING ((SELECT auth.uid()) = id);
```

#### 3. Storage for Blog Images

Blogify uses Supabase storage for handling blog cover images.

```sql
-- Create a storage bucket for blog images
INSERT INTO storage.buckets (id, name)
  VALUES ('blog_images', 'blog_images');

-- Policies for storage access control
CREATE POLICY "Blog images are publicly accessible." ON storage.objects
  FOR SELECT USING (bucket_id = 'blog_images');

CREATE POLICY "Anyone can upload a blog image." ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'blog_images');

CREATE POLICY "Anyone can update their own blog images." ON storage.objects
  FOR UPDATE USING ((SELECT auth.uid()) = owner) WITH CHECK (bucket_id = 'blog_images');
```

### Automatic Profile Creation on User Signup

A trigger and function are implemented to automatically create a profile entry when a new user signs up.

```sql
-- Function to handle new user signup
CREATE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, name)
  VALUES (new.id, new.raw_user_meta_data->>'name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to execute the function on user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

### Contributions and Further Information

If you would like to contribute or require more detailed explanations about the Supabase setup, feel free to reach out or refer to the [Supabase documentation](https://supabase.com/docs/guides/getting-started/quickstarts/flutter).

---

## Installation

To get started with Blogify, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/blogify.git
   ```

2. **Install dependencies:**

   ```bash
   cd blogify
   flutter pub get
   ```

3. **Set up Supabase:**

   - Create a Supabase account and a new project.
   - Configure your `lib/core/secrets/app_secrets.dart` file with your Supabase credentials.

4. **Run the app:**

   ```bash
   flutter run
   ```

---

## Contributing

Contributions are welcome! Please fork the repository and use a feature branch for any changes. Pull requests are warmly welcomed.
