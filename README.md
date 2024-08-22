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

Here's a detailed visualization of the project structure:

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