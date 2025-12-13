# Blogify

[![wakatime](https://wakatime.com/badge/user/018c9017-daf8-45c1-be71-8b16fd238022/project/0a155339-8a16-4ffb-a6db-0e2f32481c0f.svg)](https://wakatime.com/badge/user/018c9017-daf8-45c1-be71-8b16fd238022/project/0a155339-8a16-4ffb-a6db-0e2f32481c0f)

**Blogify** is a modern, feature-rich blogging platform built with Flutter and Supabase. It provides a seamless and visually appealing experience for users to create, share, and manage blogs. Designed with clean architecture, Blogify ensures a scalable, maintainable, and testable codebase, making it ideal for developers and contributors who value high-quality standards.

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Project Structure](#project-structure)
- [Supabase Backend Structure](#supabase-backend-structure)
- [Contributing](#contributing)
- [Roadmap](#roadmap)

---

## Features

### Authentication
- [x] User Sign Up with validation
- [x] User Sign In with validation
- [x] Current User Session Management
- [x] Secure password requirements

### Blog Management
- [x] Create New Blogs with cover images
- [x] View All Blogs with Pull to Refresh
- [x] Blog Detail View with reading time
- [x] Share Blogs via native share sheet
- [ ] Edit Blogs
- [ ] Delete Blogs

### User Interface
- [x] Professional and modern UI
- [x] Dark/Light theme support
- [x] Responsive design for mobile devices
- [x] Smooth animations and transitions
- [x] Custom animated loader

### Utilities
- [x] Image Picker for blog cover images
- [x] Snackbar Notifications with types (success, error, warning, info)
- [x] Date Formatting and Reading Time Calculation
- [x] Input validation for all forms

---

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.38+** | Cross-platform UI framework |
| **Dart 3.10+** | Programming language |
| **Supabase** | Backend (Auth, Database, Storage) |
| **flutter_bloc** | State management |
| **get_it** | Dependency injection |
| **equatable** | Value equality for entities/states |
| **dartz** | Functional programming (Either type) |
| **share_plus** | Native sharing functionality |
| **cached_network_image** | Image caching |

---

## Architecture

Blogify follows **Clean Architecture** with three distinct layers:

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  (Pages, Widgets, BLoC/Cubits)                          │
├─────────────────────────────────────────────────────────┤
│                      Domain Layer                        │
│  (Entities, UseCases, Repository Interfaces)            │
├─────────────────────────────────────────────────────────┤
│                       Data Layer                         │
│  (Models, Data Sources, Repository Implementations)     │
└─────────────────────────────────────────────────────────┘
```

### Data Flow
1. UI dispatches **Event** to BLoC
2. BLoC calls **UseCase**
3. UseCase calls **Repository** (interface)
4. Repository implementation calls **DataSource**
5. DataSource interacts with **Supabase**
6. Result flows back as `Either<Failure, SuccessType>`
7. BLoC emits new **State**

---

## Getting Started

### Prerequisites

- Flutter SDK 3.38.4 or higher
- Dart SDK 3.10.0 or higher
- A Supabase account and project

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mahmoodhamdi/blogify.git
   cd blogify
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

### Configuration

1. **Create environment file:**

   Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. **Add your Supabase credentials to `.env`:**
   ```env
   SUPABASE_URL=your_supabase_url_here
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   ```

3. **Set up Supabase:**
   - Create a new Supabase project
   - Run the SQL scripts from the [Supabase Backend Structure](#supabase-backend-structure) section
   - Create a storage bucket named `blog_images`

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## Running Tests

Blogify includes comprehensive unit tests for core utilities and validators.

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/core/validators/validation_test.dart
```

### Test Structure
```
test/
├── core/
│   ├── utils/
│   │   ├── calculate_reading_time_test.dart
│   │   └── format_date_test.dart
│   └── validators/
│       └── validation_test.dart
└── widget_test.dart
```

---

## Project Structure

```
lib/
├── core/
│   ├── common/
│   │   ├── cubits/app_user/     # App-wide user state
│   │   ├── entities/            # Shared entities
│   │   └── widgets/             # Reusable widgets
│   ├── error/                   # Exception & Failure classes
│   ├── network/                 # Connection checker
│   ├── secrets/                 # Environment configuration
│   ├── theme/                   # App themes & colors
│   ├── usecase/                 # Base UseCase interface
│   ├── utils/                   # Utility functions
│   └── validators/              # Input validation
├── features/
│   ├── auth/
│   │   ├── data/               # Data sources, models, repos
│   │   ├── domain/             # Entities, repos interface, usecases
│   │   └── presentation/       # BLoC, pages, widgets
│   └── blog/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── init_dependencies.dart      # Dependency injection setup
└── main.dart                   # App entry point
```

---

## Supabase Backend Structure

### Database Schema

![Database Schema](https://github.com/user-attachments/assets/d9578a3e-2048-4689-b2b0-7b4d3bfb3227)

### Database Tables and Policies

#### 1. Profiles Table

```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE,
  name TEXT,
  CONSTRAINT name_length CHECK (char_length(name) >= 3)
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone." ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON profiles
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update their own profile." ON profiles
  FOR UPDATE USING ((SELECT auth.uid()) = id);
```

#### 2. Blogs Table

```sql
CREATE TABLE blogs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  poster_id UUID REFERENCES auth.users NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  topics _TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public blogs are viewable by everyone." ON blogs
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own blogs." ON blogs
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = poster_id);

CREATE POLICY "Users can update their own blogs." ON blogs
  FOR UPDATE USING ((SELECT auth.uid()) = poster_id);

CREATE POLICY "Users can delete their own blogs." ON blogs
  FOR DELETE USING ((SELECT auth.uid()) = poster_id);
```

#### 3. Storage for Blog Images

```sql
INSERT INTO storage.buckets (id, name) VALUES ('blog_images', 'blog_images');

CREATE POLICY "Blog images are publicly accessible." ON storage.objects
  FOR SELECT USING (bucket_id = 'blog_images');

CREATE POLICY "Anyone can upload a blog image." ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'blog_images');

CREATE POLICY "Anyone can update their own blog images." ON storage.objects
  FOR UPDATE USING ((SELECT auth.uid()) = owner) WITH CHECK (bucket_id = 'blog_images');
```

#### 4. Automatic Profile Creation

```sql
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

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`flutter test`)
5. Ensure code passes analysis (`flutter analyze`)
6. Commit your changes (`git commit -m 'feat: add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Adding/updating tests
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

---

## Roadmap

### Near-term
- [ ] Edit Blogs functionality
- [ ] Delete Blogs functionality
- [ ] User Profile pages
- [ ] Blog search with filters

### Medium-term
- [ ] Comment system
- [ ] Blog drafts
- [ ] Push notifications
- [ ] Offline mode with local caching

### Long-term
- [ ] Markdown editor support
- [ ] Blog analytics
- [ ] CI/CD with GitHub Actions
- [ ] Web and desktop support

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Contact

- **Author:** Mahmood Hamdi
- **Email:** hmdy7486@gmail.com
- **GitHub:** [@mahmoodhamdi](https://github.com/mahmoodhamdi)
