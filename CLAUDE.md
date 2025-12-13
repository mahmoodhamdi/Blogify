# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device_id>

# Analyze code for issues
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/core/validators/validation_test.dart

# Run tests with coverage
flutter test --coverage

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## Environment Setup

1. Copy `.env.example` to `.env`
2. Add Supabase credentials:
   ```env
   SUPABASE_URL=your_supabase_url_here
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   ```
3. Credentials are loaded via `flutter_dotenv` in `AppSecrets`

## Architecture Overview

Blogify is a Flutter blogging app using **Clean Architecture** with **BLoC pattern** for state management and **Supabase** as the backend.

### Layer Structure

Each feature follows a three-layer architecture:

```
features/<feature_name>/
├── data/
│   ├── datasources/    # Remote/local data sources (Supabase calls)
│   ├── models/         # Data models (JSON serialization)
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces (contracts)
│   └── usecases/       # Business logic operations
└── presentation/
    ├── bloc/           # BLoC (events, states, bloc)
    ├── pages/          # UI screens
    └── widgets/        # Reusable UI components
```

### Core Module (`lib/core/`)

- **common/cubits/**: App-wide state (`AppUserCubit` for user session)
- **common/entities/**: Shared entities across features
- **common/widgets/**: Reusable widgets (`GradientButton`, `Loader`, `ChoiceChipWidget`)
- **constants/**: App constants including blog `topics` list
- **error/**: `Failure` and `ServerException` classes for error handling
- **network/**: `ConnectionChecker` for internet connectivity
- **secrets/**: `AppSecrets` - loads Supabase credentials from `.env`
- **theme/**: `AppPallete` for colors, `AppTheme` for light/dark themes
- **usecase/**: Base `UseCase<SuccessType, Params>` interface using `Either<Failure, SuccessType>`
- **utils/**: Utilities (`showSnackbar`, `pickImage`, `formatDate`, `calculateReadingTime`)
- **validators/**: Input validation logic

### Dependency Injection

Uses **GetIt** (`serviceLocator`) initialized in `init_dependencies.dart` with part file `init_dependencies.main.dart`:
- `_initAuth()`: Registers auth data sources, repository, usecases, and `AuthBloc`
- `_initBlog()`: Registers blog data sources, repository, usecases, and `BlogBloc`
- `_initProfile()`: Registers profile data sources, repository, usecases, and `ProfileBloc`

### State Management

- **BLoC** for feature-specific state (`AuthBloc`, `BlogBloc`, `ProfileBloc`)
- **Cubit** for app-wide state (`AppUserCubit`)
- All provided via `MultiBlocProvider` in `main.dart`

### Data Flow Pattern

1. UI dispatches **Event** to BLoC
2. BLoC calls **UseCase**
3. UseCase calls **Repository** (interface)
4. Repository implementation calls **DataSource**
5. DataSource interacts with **Supabase**
6. Result flows back as `Either<Failure, SuccessType>`
7. BLoC emits new **State**

## Testing

Tests use **mocktail** for mocking. Structure mirrors `lib/`:

```
test/
├── core/
│   ├── utils/              # Unit tests for utilities
│   └── validators/         # Validation tests
└── features/
    ├── auth/domain/usecases/
    └── blog/domain/usecases/
```

## Supabase Configuration

Database tables: `profiles`, `blogs`
Storage bucket: `blog_images`

Key RLS policies ensure users can only modify their own content.

## Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Adding/updating tests
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks
