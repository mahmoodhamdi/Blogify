# Feature Implementation Plan

## 1. User Profile Page

### Current State
The profile feature is already implemented with:
- `ProfilePage` - Shows user info (avatar, name, email) and user's blogs list with pagination
- `ProfileBloc` - Handles fetching user blogs with pagination
- `ProfileRepository` - Interface and implementation for profile data
- `ProfileRemoteDataSource` - Supabase integration for fetching user blogs
- `ProfileHeader` - Widget displaying user avatar with initials

### Issues to Fix
1. **Bug in ProfileRepositoryImpl**: Missing `ConnectionChecker` dependency (inconsistent with `BlogRepositoryImpl`)
2. **Missing tests**: No unit tests for profile feature

### Implementation Steps
1. ✅ ProfilePage UI - Already complete
2. ✅ ProfileBloc - Already complete
3. ✅ ProfileRepository - Already complete
4. ✅ ProfileRemoteDataSource - Already complete
5. ✅ ProfileHeader widget - Already complete
6. ✅ DI registration - Already complete in `init_dependencies.main.dart`
7. ✅ Navigation - Profile accessible from BlogPage via person icon
8. ⏳ Fix: Add ConnectionChecker to ProfileRepositoryImpl for network checking
9. ⏳ Add unit tests for GetUserBlogs usecase
10. ⏳ Add unit tests for ProfileBloc

### Navigation Flow
```
BlogPage -> Profile Icon -> ProfilePage
                              ├── ProfileHeader (name, email, avatar)
                              ├── My Blogs section
                              └── Logout button (with confirmation dialog)
```

---

## 2. Blog Search Functionality

### Approach
Add search capability to the BlogPage to filter blogs by title, content, or topics.

### Implementation Steps
1. Create `SearchBlogs` usecase in `lib/features/blog/domain/usecases/`
2. Add search method to `BlogRepository` and `BlogRemoteDataSource`
3. Add search events and states to `BlogBloc`
4. Add search bar UI to `BlogPage`
5. Implement debounced search for better UX
6. Add filter by topics functionality
7. Write unit tests for search usecase
8. Write widget tests for search UI

### UI Flow
```
BlogPage
├── AppBar
│   └── Search Icon -> Expands to SearchBar
├── Optional: Topic filter chips
└── Blog list (filtered results or all blogs)
```

### Supabase Query
```dart
supabaseClient
    .from('blogs')
    .select('*, profiles (name)')
    .or('title.ilike.%$query%,content.ilike.%$query%')
    .order('updated_at', ascending: false)
```

---

## 3. Improved Error Handling

### Status: COMPLETED

### What Was Implemented
1. **Typed Failures** (`lib/core/error/failures.dart`):
   - `NetworkFailure` - No internet connection (isRetryable: true)
   - `ServerFailure` - Server-side errors with optional status code
   - `AuthFailure` - Authentication errors (isRetryable: false)
   - `AuthorizationFailure` - Not allowed to perform action
   - `ValidationFailure` - Input validation with field errors
   - `CacheFailure` - Local storage errors
   - `NotFoundFailure` - Resource not found
   - `UnknownFailure` - Unexpected errors

2. **Typed Exceptions** (`lib/core/error/exceptions.dart`):
   - `AppException` - Base sealed class
   - `ServerException` - With optional statusCode
   - `AppAuthException` - Auth errors (renamed to avoid Supabase conflict)
   - `AuthorizationException` - Permission errors
   - `NetworkException` - Network errors
   - `CacheException` - Cache errors
   - `NotFoundException` - Not found errors

3. **Error Mapper** (`lib/core/error/error_mapper.dart`):
   - Maps exceptions to appropriate failure types
   - Provides user-friendly error messages
   - Pattern matches on server error messages

4. **Updated Repositories**:
   - BlogRepositoryImpl - Uses NetworkFailure, ServerFailure
   - ProfileRepositoryImpl - Uses NetworkFailure, ServerFailure
   - AuthRepositoryImpl - Uses NetworkFailure, AuthFailure, ServerFailure

5. **Updated Tests** - All tests updated to use typed failures

---

## Execution Order
1. ✅ Fix Profile feature bug + add tests
2. ✅ Implement Blog Search
3. ✅ Implement Improved Error Handling

All features tested and committed separately.
