# Likes/Bookmarks System Feature

## Overview
The Likes/Bookmarks system allows users to express appreciation for blog posts and save posts for later reading.

## Implementation Details

### Database Schema (schema_v2.sql)

#### Likes Table
```sql
CREATE TABLE public.likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);
```

#### Bookmarks Table
```sql
CREATE TABLE public.bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);
```

#### Auto-updating likes_count
- Trigger functions automatically increment/decrement `likes_count` on the blogs table
- Uses SECURITY DEFINER for proper permissions

### Application Architecture

#### Domain Layer
- **Blog Entity**: Added `likesCount`, `isLiked`, `isBookmarked` fields
- **Usecases**:
  - `ToggleLike`: Toggle like status for a blog
  - `ToggleBookmark`: Toggle bookmark status for a blog
  - `GetBookmarkedBlogs`: Fetch user's bookmarked blogs with pagination

#### Data Layer
- **BlogModel**: Updated with new fields and `copyWith` for state management
- **BlogRemoteDataSource**: Added methods for likes/bookmarks operations
- **BlogRepositoryImpl**: Implemented all new repository methods

#### Presentation Layer
- **BlogBloc Events**:
  - `BlogToggleLike`
  - `BlogToggleBookmark`
  - `BlogFetchBookmarks`
  - `BlogFetchMoreBookmarks`
- **BlogBloc States**:
  - `BlogLikeToggled`
  - `BlogBookmarkToggled`
  - `BlogBookmarksDisplaySuccess`

### UI Components

#### BlogViewerPage
- Like button in app bar (heart icon)
- Bookmark button in app bar
- Like count and bookmark status displayed in content area
- Real-time state updates via BlocListener

#### BookmarksPage
- Dedicated page for viewing bookmarked blogs
- Accessible from main blog page toolbar
- Pull-to-refresh support
- Infinite scroll pagination

#### BlogPage
- Bookmark icon in app bar to navigate to BookmarksPage

## How to Use

### Setup Database
Run `supabase/schema_v2.sql` in Supabase SQL Editor after initial schema setup.

### Using Likes
1. Open any blog post
2. Tap the heart icon in the app bar or content area
3. Like count updates automatically
4. Tap again to unlike

### Using Bookmarks
1. Open any blog post
2. Tap the bookmark icon in the app bar or content area
3. Blog is saved to bookmarks
4. Access bookmarks from the bookmark icon on the main blog page
5. Tap bookmark icon again to remove from bookmarks

## Testing
Tests are located in:
- `test/features/blog/domain/usecases/toggle_like_test.dart`
- `test/features/blog/domain/usecases/toggle_bookmark_test.dart`
- `test/features/blog/domain/usecases/get_bookmarked_blogs_test.dart`

Run tests with:
```bash
flutter test
```

## Files Modified/Created

### New Files
- `lib/features/blog/domain/usecases/toggle_like.dart`
- `lib/features/blog/domain/usecases/toggle_bookmark.dart`
- `lib/features/blog/domain/usecases/get_bookmarked_blogs.dart`
- `lib/features/blog/presentation/pages/bookmarks_page.dart`
- `supabase/schema_v2.sql`
- `test/features/blog/domain/usecases/toggle_like_test.dart`
- `test/features/blog/domain/usecases/toggle_bookmark_test.dart`
- `test/features/blog/domain/usecases/get_bookmarked_blogs_test.dart`

### Modified Files
- `lib/features/blog/domain/entities/blog.dart`
- `lib/features/blog/data/models/blog_model.dart`
- `lib/features/blog/domain/repositories/blog_repository.dart`
- `lib/features/blog/data/datasources/blog_remote_data_source.dart`
- `lib/features/blog/data/repositories/blog_repository_impl.dart`
- `lib/features/blog/presentation/bloc/blog_bloc.dart`
- `lib/features/blog/presentation/bloc/blog_event.dart`
- `lib/features/blog/presentation/bloc/blog_state.dart`
- `lib/features/blog/presentation/pages/blog_viewer_page.dart`
- `lib/features/blog/presentation/pages/blog_page.dart`
- `lib/init_dependencies.dart`
- `lib/init_dependencies.main.dart`
