# Blogify Improvement Plan

## Overview
This document outlines a comprehensive improvement plan for the Blogify Flutter application. Each section includes detailed implementation steps, affected files, and testing requirements.

---

## Phase 1: Core Missing Features

### 1.1 Edit Blog Functionality
**Priority:** High
**Status:** Not Implemented

#### Description
Allow users to edit their own blogs after creation.

#### Implementation Steps

1. **Domain Layer**
   - Create `UpdateBlog` use case in `lib/features/blog/domain/usecases/update_blog.dart`
   - Add `updateBlog` method to `BlogRepository` interface

2. **Data Layer**
   - Add `updateBlog` method to `BlogRemoteDataSource`
   - Implement in `BlogRemoteDataSourceImpl` using Supabase update query
   - Handle image update (delete old, upload new if changed)

3. **Presentation Layer**
   - Add `BlogUpdate` event to `blog_event.dart`
   - Handle event in `BlogBloc`
   - Create `EditBlogPage` (reuse `AddNewBlogPage` components)
   - Add edit button to `BlogViewerPage` (only for blog owner)

4. **Dependency Injection**
   - Register `UpdateBlog` use case in `init_dependencies.main.dart`

#### Files to Create/Modify
```
lib/features/blog/domain/usecases/update_blog.dart (new)
lib/features/blog/domain/repositories/blog_repository.dart
lib/features/blog/data/datasources/blog_remote_data_source.dart
lib/features/blog/data/repositories/blog_repository_impl.dart
lib/features/blog/presentation/bloc/blog_bloc.dart
lib/features/blog/presentation/bloc/blog_event.dart
lib/features/blog/presentation/bloc/blog_state.dart
lib/features/blog/presentation/pages/edit_blog_page.dart (new)
lib/features/blog/presentation/pages/blog_viewer_page.dart
lib/init_dependencies.main.dart
```

#### Test Requirements
- Unit test for `UpdateBlog` use case
- Unit test for repository implementation
- Widget test for `EditBlogPage`
- Integration test for edit flow

---

### 1.2 Delete Blog Functionality
**Priority:** High
**Status:** Not Implemented

#### Description
Allow users to delete their own blogs with confirmation dialog.

#### Implementation Steps

1. **Domain Layer**
   - Create `DeleteBlog` use case in `lib/features/blog/domain/usecases/delete_blog.dart`
   - Add `deleteBlog` method to `BlogRepository` interface

2. **Data Layer**
   - Add `deleteBlog` method to `BlogRemoteDataSource`
   - Implement deletion with cascade (delete image from storage)
   - Use Supabase RLS policy (already exists for delete)

3. **Presentation Layer**
   - Add `BlogDelete` event to `blog_event.dart`
   - Add `BlogDeleteSuccess` state
   - Handle event in `BlogBloc`
   - Add delete button with confirmation dialog to `BlogViewerPage`
   - Show delete option only for blog owner

4. **UI Components**
   - Create confirmation dialog widget
   - Add swipe-to-delete on `BlogCard` (optional)

#### Files to Create/Modify
```
lib/features/blog/domain/usecases/delete_blog.dart (new)
lib/features/blog/domain/repositories/blog_repository.dart
lib/features/blog/data/datasources/blog_remote_data_source.dart
lib/features/blog/data/repositories/blog_repository_impl.dart
lib/features/blog/presentation/bloc/blog_bloc.dart
lib/features/blog/presentation/bloc/blog_event.dart
lib/features/blog/presentation/bloc/blog_state.dart
lib/features/blog/presentation/pages/blog_viewer_page.dart
lib/core/common/widgets/confirmation_dialog.dart (new)
lib/init_dependencies.main.dart
```

#### Test Requirements
- Unit test for `DeleteBlog` use case
- Widget test for confirmation dialog
- Integration test for delete flow

---

### 1.3 User Logout Functionality
**Priority:** High
**Status:** Not Implemented

#### Description
Allow users to log out and clear their session.

#### Implementation Steps

1. **Domain Layer**
   - Create `UserLogout` use case in `lib/features/auth/domain/usecases/user_logout.dart`
   - Add `logout` method to `AuthRepository` interface

2. **Data Layer**
   - Add `logout` method to `AuthRemoteDataSource`
   - Call `supabaseClient.auth.signOut()`

3. **Presentation Layer**
   - Add `AuthLogout` event to `auth_event.dart`
   - Add `AuthLogoutSuccess` state
   - Handle event in `AuthBloc`
   - Update `AppUserCubit` to clear user state
   - Add logout button to app (settings/profile menu)

4. **Navigation**
   - Navigate to login page after logout
   - Clear navigation stack

#### Files to Create/Modify
```
lib/features/auth/domain/usecases/user_logout.dart (new)
lib/features/auth/domain/repository/auth_repository.dart
lib/features/auth/data/datasources/auth_remote_data_source.dart
lib/features/auth/data/repositories/auth_repository_impl.dart
lib/features/auth/presentation/bloc/auth_bloc.dart
lib/features/auth/presentation/bloc/auth_event.dart
lib/features/auth/presentation/bloc/auth_state.dart
lib/core/common/cubits/app_user/app_user_cubit.dart
lib/features/blog/presentation/pages/blog_page.dart
lib/init_dependencies.main.dart
```

#### Test Requirements
- Unit test for `UserLogout` use case
- Integration test for logout flow

---

## Phase 2: User Experience Improvements

### 2.1 User Profile Page
**Priority:** Medium
**Status:** Not Implemented

#### Description
Create a user profile page showing user info and their blogs.

#### Implementation Steps

1. **Domain Layer**
   - Create `GetUserBlogs` use case
   - Create `UpdateProfile` use case

2. **Data Layer**
   - Add `getUserBlogs` method (filter by poster_id)
   - Add `updateProfile` method

3. **Presentation Layer**
   - Create `ProfilePage` with:
     - User avatar (with initial letter)
     - User name and email
     - Edit profile button
     - List of user's blogs
     - Logout button
   - Create `ProfileCubit` for profile state

4. **Navigation**
   - Add profile icon to `BlogPage` AppBar
   - Navigate to `ProfilePage`

#### Files to Create/Modify
```
lib/features/profile/ (new feature folder)
  ├── data/
  │   ├── datasources/profile_remote_data_source.dart
  │   └── repositories/profile_repository_impl.dart
  ├── domain/
  │   ├── repositories/profile_repository.dart
  │   └── usecases/
  │       ├── get_user_blogs.dart
  │       └── update_profile.dart
  └── presentation/
      ├── bloc/profile_bloc.dart
      ├── pages/profile_page.dart
      └── widgets/
          ├── profile_header.dart
          └── user_blog_list.dart
```

---

### 2.2 Blog Search and Filter
**Priority:** Medium
**Status:** Not Implemented

#### Description
Add search functionality to find blogs by title, content, or topics.

#### Implementation Steps

1. **Domain Layer**
   - Create `SearchBlogs` use case with query parameters

2. **Data Layer**
   - Implement Supabase text search using `ilike` or full-text search

3. **Presentation Layer**
   - Add search bar to `BlogPage`
   - Create `SearchBlogsPage` with filters:
     - Text search
     - Topic filter
     - Date range filter
   - Real-time search with debounce

4. **State Management**
   - Add search events and states to `BlogBloc`
   - Or create separate `SearchBloc`

#### Files to Create/Modify
```
lib/features/blog/domain/usecases/search_blogs.dart (new)
lib/features/blog/data/datasources/blog_remote_data_source.dart
lib/features/blog/presentation/bloc/blog_bloc.dart
lib/features/blog/presentation/pages/search_blogs_page.dart (new)
lib/features/blog/presentation/widgets/search_bar_widget.dart (new)
lib/features/blog/presentation/widgets/topic_filter_chips.dart (new)
```

---

### 2.3 Blog Bookmarks/Favorites
**Priority:** Medium
**Status:** Not Implemented

#### Description
Allow users to bookmark blogs for later reading.

#### Implementation Steps

1. **Database Schema**
   - Create `bookmarks` table in Supabase:
   ```sql
   CREATE TABLE bookmarks (
     id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
     user_id UUID REFERENCES auth.users NOT NULL,
     blog_id UUID REFERENCES blogs NOT NULL,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
     UNIQUE(user_id, blog_id)
   );
   ```

2. **Domain Layer**
   - Create `Bookmark` entity
   - Create use cases: `AddBookmark`, `RemoveBookmark`, `GetBookmarks`

3. **Presentation Layer**
   - Add bookmark icon to `BlogCard` and `BlogViewerPage`
   - Create `BookmarksPage` to list bookmarked blogs
   - Add bookmarks tab to profile

---

### 2.4 Improved Error Handling
**Priority:** High
**Status:** Partial

#### Description
Implement comprehensive error handling with user-friendly messages and retry options.

#### Implementation Steps

1. **Create Error Types**
   - Network errors
   - Authentication errors
   - Server errors
   - Validation errors

2. **Error UI Components**
   - Create `ErrorWidget` with retry button
   - Create `NetworkErrorWidget` for offline state
   - Add error boundaries

3. **Retry Logic**
   - Implement exponential backoff for network requests
   - Add retry button on failure states

#### Files to Create/Modify
```
lib/core/error/failures.dart (enhance)
lib/core/common/widgets/error_widget.dart (new)
lib/core/common/widgets/network_error_widget.dart (new)
lib/core/network/retry_interceptor.dart (new)
```

---

## Phase 3: New Features

### 3.1 Blog Comments System
**Priority:** Medium
**Status:** Not Implemented

#### Description
Allow users to comment on blogs and reply to comments.

#### Implementation Steps

1. **Database Schema**
   ```sql
   CREATE TABLE comments (
     id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
     blog_id UUID REFERENCES blogs NOT NULL,
     user_id UUID REFERENCES auth.users NOT NULL,
     parent_id UUID REFERENCES comments,
     content TEXT NOT NULL,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **Feature Structure**
   ```
   lib/features/comments/
   ├── data/
   ├── domain/
   └── presentation/
   ```

3. **UI Components**
   - Comment list in `BlogViewerPage`
   - Comment input field
   - Reply functionality
   - Edit/Delete own comments

---

### 3.2 Blog Drafts
**Priority:** Low
**Status:** Not Implemented

#### Description
Allow users to save blog drafts locally before publishing.

#### Implementation Steps

1. **Local Storage**
   - Use `shared_preferences` or `hive` for local storage
   - Create `DraftBlog` model

2. **Draft Management**
   - Auto-save drafts every 30 seconds
   - List drafts in "My Drafts" section
   - Convert draft to published blog

3. **UI**
   - "Save as Draft" button in `AddNewBlogPage`
   - Drafts list in profile

---

### 3.3 Push Notifications
**Priority:** Low
**Status:** Not Implemented

#### Description
Notify users about new comments, likes, or featured blogs.

#### Implementation Steps

1. **Setup**
   - Integrate Firebase Cloud Messaging (FCM)
   - Configure Supabase Edge Functions for triggers

2. **Notification Types**
   - New comment on your blog
   - Reply to your comment
   - Weekly digest of popular blogs

---

### 3.4 Rich Text Editor
**Priority:** Medium
**Status:** Not Implemented

#### Description
Replace plain text editor with rich text/markdown support.

#### Implementation Steps

1. **Dependencies**
   - Add `flutter_quill` or `markdown_editable_textinput`

2. **Implementation**
   - Replace `BlogEditor` with rich text editor
   - Support: bold, italic, headers, lists, code blocks
   - Store content as markdown/delta format

3. **Rendering**
   - Use `flutter_markdown` for rendering in `BlogViewerPage`

---

## Phase 4: Technical Improvements

### 4.1 Offline Support with Local Caching
**Priority:** Medium
**Status:** Not Implemented

#### Description
Cache blogs locally for offline reading.

#### Implementation Steps

1. **Local Database**
   - Add `hive` or `sqflite` dependency
   - Create local data source interfaces

2. **Repository Pattern**
   - Check network connectivity
   - Fetch from local if offline
   - Sync when back online

3. **Cache Strategy**
   - Cache blogs on first fetch
   - Update cache on pull-to-refresh
   - Show cached data with "offline" indicator

#### Files to Create/Modify
```
lib/features/blog/data/datasources/blog_local_data_source.dart (new)
lib/features/blog/data/repositories/blog_repository_impl.dart
lib/core/database/hive_database.dart (new)
```

---

### 4.2 Image Optimization
**Priority:** Medium
**Status:** Not Implemented

#### Description
Compress and optimize images before upload.

#### Implementation Steps

1. **Dependencies**
   - Add `flutter_image_compress` package

2. **Implementation**
   - Compress images before upload (max 1MB)
   - Generate thumbnails for blog list
   - Progressive image loading

#### Files to Modify
```
lib/core/utils/image_utils.dart (new)
lib/features/blog/data/datasources/blog_remote_data_source.dart
```

---

### 4.3 Pagination for Blog List
**Priority:** High
**Status:** Not Implemented

#### Description
Implement infinite scroll pagination for better performance.

#### Implementation Steps

1. **Data Layer**
   - Modify `getAllBlogs` to accept `page` and `limit` parameters
   - Use Supabase `range()` for pagination

2. **Presentation Layer**
   - Implement infinite scroll in `BlogPage`
   - Show loading indicator at bottom
   - Handle "no more blogs" state

#### Files to Modify
```
lib/features/blog/domain/usecases/get_all_blogs.dart
lib/features/blog/data/datasources/blog_remote_data_source.dart
lib/features/blog/presentation/bloc/blog_bloc.dart
lib/features/blog/presentation/pages/blog_page.dart
```

---

### 4.4 Analytics and Monitoring
**Priority:** Low
**Status:** Not Implemented

#### Description
Track app usage and errors for improvement insights.

#### Implementation Steps

1. **Setup**
   - Integrate Firebase Analytics
   - Add Crashlytics for error reporting

2. **Events to Track**
   - Blog views
   - Blog creation
   - Search queries
   - User engagement

---

## Phase 5: Testing Coverage

### 5.1 Unit Tests
**Current Coverage:** ~30%
**Target Coverage:** 80%

#### Missing Tests
- [ ] Auth Repository tests
- [ ] Blog Repository tests
- [ ] All Use Case tests
- [ ] Model serialization tests
- [ ] BLoC tests

### 5.2 Widget Tests
**Current Coverage:** ~10%
**Target Coverage:** 60%

#### Missing Tests
- [ ] LoginPage widget test
- [ ] SignupPage widget test
- [ ] BlogPage widget test
- [ ] BlogViewerPage widget test
- [ ] AddNewBlogPage widget test

### 5.3 Integration Tests
**Current Coverage:** 0%
**Target Coverage:** 40%

#### Tests to Add
- [ ] Full authentication flow
- [ ] Blog CRUD operations
- [ ] Navigation flow

---

## Phase 6: Code Quality

### 6.1 Refactoring Tasks

1. **Extract Common Widgets**
   - Create `AppTextField` to replace duplicate code
   - Create `AppButton` variants
   - Create `AppCard` base widget

2. **Constants Organization**
   - Move all strings to constants file
   - Create `AppStrings` class for UI text
   - Support for localization (l10n)

3. **Theme Improvements**
   - Complete theme data for all components
   - Add text themes
   - Add button themes

### 6.2 Code Documentation

1. **Add Documentation**
   - Document all public APIs
   - Add README to each feature folder
   - Create architecture decision records (ADRs)

---

## Implementation Priority Order

### Sprint 1 (Core Features)
1. User Logout
2. Delete Blog
3. Edit Blog
4. Pagination

### Sprint 2 (UX Improvements)
5. User Profile Page
6. Blog Search
7. Improved Error Handling

### Sprint 3 (New Features)
8. Blog Bookmarks
9. Comments System
10. Rich Text Editor

### Sprint 4 (Technical)
11. Offline Support
12. Image Optimization
13. Analytics

### Sprint 5 (Quality)
14. Comprehensive Testing
15. Code Refactoring
16. Documentation

---

## Success Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Test Coverage | 30% | 80% |
| Flutter Analyze Issues | 0 | 0 |
| Features Implemented | 60% | 100% |
| User Retention (est.) | - | +40% |

---

## Notes

- Each feature should follow Clean Architecture
- All new code must have tests
- PRs require code review
- Follow conventional commits
- Update README after major features

---

*Last Updated: December 13, 2025*
