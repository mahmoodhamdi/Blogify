# Sprint 2 - Feature Implementation Plan

## Overview
Implementation of 6 new features for Blogify app.

---

## 1. Dark Mode (Theme Switching)

### Database Changes
None required - theme preference stored locally.

### Implementation Steps
1. Create `ThemeCubit` in `lib/core/common/cubits/theme/`
2. Add theme persistence using Hive
3. Update `AppTheme` to include dark theme colors
4. Add theme toggle in ProfilePage settings
5. Wrap app with `BlocBuilder<ThemeCubit, ThemeState>`

### Files to Create/Modify
- `lib/core/common/cubits/theme/theme_cubit.dart` (new)
- `lib/core/common/cubits/theme/theme_state.dart` (new)
- `lib/core/theme/app_theme.dart` (modify - add dark theme)
- `lib/core/theme/app_pallete.dart` (modify - add dark colors)
- `lib/main.dart` (modify - add ThemeCubit provider)
- `lib/features/profile/presentation/pages/profile_page.dart` (modify - add toggle)
- `lib/init_dependencies.dart` (modify - register ThemeCubit)

### Testing
- Unit tests for ThemeCubit
- Verify theme persists across app restarts

---

## 2. User Profile Edit

### Database Changes
None - profiles table already supports updates.

### Implementation Steps
1. Create `UpdateProfile` usecase
2. Add `updateProfile` method to ProfileRepository
3. Create `EditProfilePage` with form (name, avatar)
4. Add image upload for profile avatar
5. Update ProfileBloc with edit events/states

### Files to Create/Modify
- `lib/features/profile/domain/usecases/update_profile.dart` (new)
- `lib/features/profile/domain/repositories/profile_repository.dart` (modify)
- `lib/features/profile/data/repositories/profile_repository_impl.dart` (modify)
- `lib/features/profile/data/datasources/profile_remote_data_source.dart` (modify)
- `lib/features/profile/presentation/pages/edit_profile_page.dart` (new)
- `lib/features/profile/presentation/bloc/profile_bloc.dart` (modify)

### Storage
- Create `profile_avatars` bucket in Supabase Storage

### Testing
- Unit tests for UpdateProfile usecase
- Integration test for profile update flow

---

## 3. Likes/Bookmarks System

### Database Changes (schema update required)
```sql
-- Likes table
CREATE TABLE public.likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);

-- Bookmarks table
CREATE TABLE public.bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);

-- Add likes_count to blogs for performance
ALTER TABLE public.blogs ADD COLUMN likes_count INTEGER DEFAULT 0;
```

### Implementation Steps
1. Update database schema
2. Create `Like` and `Bookmark` entities
3. Create usecases: `ToggleLike`, `ToggleBookmark`, `GetBookmarkedBlogs`
4. Add methods to BlogRepository
5. Update BlogCard UI with like/bookmark buttons
6. Add BookmarksPage to show saved blogs
7. Add real-time likes count update

### Files to Create
- `lib/features/blog/domain/entities/like.dart`
- `lib/features/blog/domain/entities/bookmark.dart`
- `lib/features/blog/domain/usecases/toggle_like.dart`
- `lib/features/blog/domain/usecases/toggle_bookmark.dart`
- `lib/features/blog/domain/usecases/get_bookmarked_blogs.dart`
- `lib/features/blog/presentation/pages/bookmarks_page.dart`

### Testing
- Unit tests for toggle usecases
- Verify unique constraint prevents duplicate likes

---

## 4. Comments System

### Database Changes (schema update required)
```sql
CREATE TABLE public.comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    parent_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments_count to blogs
ALTER TABLE public.blogs ADD COLUMN comments_count INTEGER DEFAULT 0;

-- RLS policies
CREATE POLICY "Anyone can view comments" ON public.comments FOR SELECT USING (true);
CREATE POLICY "Users can insert own comments" ON public.comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own comments" ON public.comments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own comments" ON public.comments FOR DELETE USING (auth.uid() = user_id);
```

### Implementation Steps
1. Update database schema
2. Create `Comment` entity and model
3. Create usecases: `GetComments`, `AddComment`, `DeleteComment`
4. Create `CommentBloc` for comments state management
5. Add comments section to BlogViewerPage
6. Create CommentCard widget
7. Add reply functionality (nested comments)

### Files to Create
- `lib/features/blog/domain/entities/comment.dart`
- `lib/features/blog/data/models/comment_model.dart`
- `lib/features/blog/domain/usecases/get_comments.dart`
- `lib/features/blog/domain/usecases/add_comment.dart`
- `lib/features/blog/domain/usecases/delete_comment.dart`
- `lib/features/blog/presentation/bloc/comment_bloc.dart`
- `lib/features/blog/presentation/widgets/comment_card.dart`
- `lib/features/blog/presentation/widgets/comments_section.dart`

### Testing
- Unit tests for comment usecases
- Unit tests for CommentBloc

---

## 5. Notifications System

### Database Changes (schema update required)
```sql
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- 'like', 'comment', 'reply'
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS policies
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (auth.uid() = user_id);
```

### Implementation Steps
1. Update database schema
2. Create `Notification` entity and model
3. Create usecases: `GetNotifications`, `MarkAsRead`, `MarkAllAsRead`
4. Create `NotificationBloc`
5. Create NotificationsPage
6. Add notification badge to AppBar
7. Trigger notifications on like/comment (database trigger or app logic)

### Files to Create
- `lib/features/notifications/domain/entities/notification.dart`
- `lib/features/notifications/data/models/notification_model.dart`
- `lib/features/notifications/domain/usecases/get_notifications.dart`
- `lib/features/notifications/domain/usecases/mark_notification_read.dart`
- `lib/features/notifications/presentation/bloc/notification_bloc.dart`
- `lib/features/notifications/presentation/pages/notifications_page.dart`
- `lib/features/notifications/presentation/widgets/notification_card.dart`

### Testing
- Unit tests for notification usecases
- Unit tests for NotificationBloc

---

## 6. Rich Text Editor

### Implementation Steps
1. Add `flutter_quill` package for rich text editing
2. Update AddNewBlogPage to use QuillEditor
3. Store content as Delta JSON format
4. Update BlogViewerPage to render rich text
5. Add image embedding in content
6. Add formatting toolbar

### Files to Modify
- `pubspec.yaml` (add flutter_quill)
- `lib/features/blog/presentation/pages/add_new_blog_page.dart`
- `lib/features/blog/presentation/pages/blog_viewer_page.dart`
- `lib/features/blog/domain/entities/blog.dart` (content type change)

### Migration Note
Existing blog content (plain text) will need a migration strategy:
- Option A: Store both plain text and rich text formats
- Option B: Convert existing content to basic Delta format

### Testing
- Widget tests for editor functionality
- Verify content saves and loads correctly

---

## Execution Order

| # | Feature | Priority | Dependencies |
|---|---------|----------|--------------|
| 1 | Dark Mode | High | None |
| 2 | User Profile Edit | High | None |
| 3 | Likes/Bookmarks | High | Schema update |
| 4 | Comments System | Medium | Schema update |
| 5 | Notifications | Medium | Comments, Likes |
| 6 | Rich Text Editor | Low | None |

---

## Schema Migration Script

Create `supabase/schema_v2.sql` with all new tables:
- likes
- bookmarks
- comments
- notifications
- Updated blogs table (likes_count, comments_count)

---

## Progress Tracking

- [ ] Dark Mode
- [ ] User Profile Edit
- [ ] Likes/Bookmarks
- [ ] Comments System
- [ ] Notifications
- [ ] Rich Text Editor
