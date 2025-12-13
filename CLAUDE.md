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

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

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

- **common/cubits/**: App-wide state (e.g., `AppUserCubit` for user session)
- **common/entities/**: Shared entities across features
- **common/widgets/**: Reusable widgets (`GradientButton`, `Loader`, `ChoiceChipWidget`)
- **error/**: `Failure` and `ServerException` classes for error handling
- **network/**: `ConnectionChecker` for internet connectivity
- **secrets/**: `AppSecrets` - Supabase credentials (URL and anon key)
- **theme/**: `AppPallete` for colors, `AppTheme` for light/dark themes
- **usecase/**: Base `UseCase<SuccessType, Params>` interface using `Either<Failure, SuccessType>` from dartz
- **utils/**: Utilities (`showSnackbar`, `pickImage`, `formatDate`, `calculateReadingTime`)
- **validators/**: Input validation logic

### Dependency Injection

Uses **GetIt** (`serviceLocator`) initialized in `init_dependencies.dart`:
- `_initAuth()`: Registers auth data sources, repository, usecases, and `AuthBloc`
- `_initBlog()`: Registers blog data sources, repository, usecases, and `BlogBloc`

### State Management

- **BLoC** for feature-specific state (`AuthBloc`, `BlogBloc`)
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

## Supabase Configuration

Credentials are stored in `lib/core/secrets/app_secrets.dart`:
- `AppSecrets.supabaseUrl`
- `AppSecrets.supabaseAnonKey`

Database tables: `profiles`, `blogs`
Storage bucket: `blog_images`

## Key Dependencies

- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **supabase_flutter**: Backend services
- **dartz**: Functional programming (`Either` type for error handling)
- **image_picker**: Blog cover image selection
- **cached_network_image**: Image caching
- **internet_connection_checker_plus**: Network status
- **hive**: Local storage
