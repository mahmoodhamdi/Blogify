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

### Current State
- Basic error handling with `Failure` class and `ServerException`
- SnackBar notifications for errors

### Improvements Needed
1. **Typed Failures**: Create specific failure types (NetworkFailure, AuthFailure, etc.)
2. **Better error messages**: User-friendly error messages instead of raw exceptions
3. **Retry mechanisms**: Add retry buttons for failed operations
4. **Offline handling**: Better UX when offline

### Implementation Steps
1. Create typed failure classes in `lib/core/error/failures.dart`:
   - `NetworkFailure` - No internet connection
   - `AuthFailure` - Authentication errors
   - `ServerFailure` - Server-side errors
   - `CacheFailure` - Local storage errors
   - `ValidationFailure` - Input validation errors

2. Update repositories to return specific failure types

3. Create error mapping utility to convert exceptions to failures

4. Update BLoCs to handle different failure types with appropriate messages

5. Add retry functionality to error states in UI

6. Write tests for error handling scenarios

### Error UI Pattern
```dart
if (state is ProfileFailure) {
  return ErrorView(
    message: state.message,
    icon: _getIconForFailureType(state.failureType),
    onRetry: _fetchUserBlogs,
    showRetry: state.isRetryable,
  );
}
```

---

## Execution Order
1. Fix Profile feature bug + add tests
2. Implement Blog Search
3. Implement Improved Error Handling

Each feature will be tested and committed separately before moving to the next.
