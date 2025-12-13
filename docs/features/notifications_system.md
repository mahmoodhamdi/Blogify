# Notifications System Feature

## Overview
The Notifications System allows users to receive real-time notifications when someone interacts with their content (likes their blogs, comments on their posts, or replies to their comments).

## Implementation Details

### Database Schema (schema_v4.sql)

#### Notifications Table
```sql
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- 'like', 'comment', 'reply', 'follow'
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    blog_id UUID REFERENCES public.blogs(id) ON DELETE CASCADE,
    comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    from_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Auto-creating Notifications
- Trigger function `create_like_notification()` creates notifications when users like blogs
- Trigger function `create_comment_notification()` creates notifications when users comment on blogs
- Notifications include the actor's user info (name, avatar)

### Application Architecture

#### Domain Layer
- **AppNotification Entity**: Contains id, userId, type, title, message, blogId, commentId, fromUserId, fromUserName, fromUserAvatarUrl, isRead, createdAt
- **NotificationType Enum**: like, comment, reply, follow
- **NotificationRepository Interface**: Defines methods for notification operations
- **Usecases**:
  - `GetNotifications`: Fetch notifications for a user with pagination
  - `MarkNotificationRead`: Mark a single notification as read
  - `MarkAllNotificationsRead`: Mark all user notifications as read
  - `GetUnreadCount`: Get count of unread notifications

#### Data Layer
- **NotificationModel**: Extends AppNotification entity with JSON serialization
- **NotificationRemoteDataSource**: Supabase API calls for notifications
- **NotificationRepositoryImpl**: Implements repository interface

#### Presentation Layer
- **NotificationBloc Events**:
  - `NotificationFetch`: Load notifications for a user
  - `NotificationFetchMore`: Load more notifications (pagination)
  - `NotificationMarkRead`: Mark single notification as read
  - `NotificationMarkAllRead`: Mark all as read
  - `NotificationFetchUnreadCount`: Get unread count
- **NotificationBloc States**:
  - `NotificationInitial`
  - `NotificationLoading`
  - `NotificationLoaded`
  - `NotificationUnreadCount`
  - `NotificationFailure`

### UI Components

#### NotificationsPage
- Displays list of notifications sorted by date (newest first)
- Pull-to-refresh functionality
- Infinite scroll pagination
- "Mark all read" button in app bar
- Empty state when no notifications
- Error state with retry button

#### NotificationCard Widget
- Displays notification with sender avatar
- Shows notification type icon (like, comment, reply, follow)
- Relative timestamp (e.g., "5m ago", "2h ago")
- Unread indicator (blue dot)
- Mark as read button for unread notifications
- Tap to navigate to relevant content

#### Notification Badge (BlogPage)
- Bell icon in app bar
- Shows unread count badge
- Animates when there are new notifications

## How to Use

### Setup Database
Run `supabase/schema_v4.sql` in Supabase SQL Editor after schema_v3.sql.

### Viewing Notifications
1. Tap the bell icon in the blog page app bar
2. See all your notifications in chronological order
3. Pull down to refresh
4. Scroll down to load more

### Managing Notifications
1. Tap any notification to mark it as read and navigate to content
2. Tap the check icon to mark individual notifications as read
3. Tap "Mark all read" to clear all unread notifications

### Notification Types
- **Like**: When someone likes your blog
- **Comment**: When someone comments on your blog
- **Reply**: When someone replies to your comment
- **Follow**: When someone follows you (future feature)

## Testing
Tests are located in:
- `test/features/notifications/domain/usecases/get_notifications_test.dart`
- `test/features/notifications/domain/usecases/mark_notification_read_test.dart`
- `test/features/notifications/domain/usecases/mark_all_notifications_read_test.dart`
- `test/features/notifications/domain/usecases/get_unread_count_test.dart`

Run tests with:
```bash
flutter test test/features/notifications/
```

## Files Created

### Domain Layer
- `lib/features/notifications/domain/entities/notification.dart`
- `lib/features/notifications/domain/repositories/notification_repository.dart`
- `lib/features/notifications/domain/usecases/get_notifications.dart`
- `lib/features/notifications/domain/usecases/mark_notification_read.dart`
- `lib/features/notifications/domain/usecases/mark_all_notifications_read.dart`
- `lib/features/notifications/domain/usecases/get_unread_count.dart`

### Data Layer
- `lib/features/notifications/data/models/notification_model.dart`
- `lib/features/notifications/data/datasources/notification_remote_data_source.dart`
- `lib/features/notifications/data/repositories/notification_repository_impl.dart`

### Presentation Layer
- `lib/features/notifications/presentation/bloc/notification_bloc.dart`
- `lib/features/notifications/presentation/bloc/notification_event.dart`
- `lib/features/notifications/presentation/bloc/notification_state.dart`
- `lib/features/notifications/presentation/pages/notifications_page.dart`
- `lib/features/notifications/presentation/widgets/notification_card.dart`

### Database
- `supabase/schema_v4.sql`

### Modified Files
- `lib/features/blog/presentation/pages/blog_page.dart` (added notification icon with badge)
- `lib/main.dart` (added NotificationBloc provider)
- `lib/init_dependencies.dart` (added notification imports)
- `lib/init_dependencies.main.dart` (added _initNotifications)

## Architecture Flow
1. User opens app → BlogPage fetches unread notification count
2. Badge shows unread count on bell icon
3. User taps bell → NotificationsPage opens
4. NotificationsPage dispatches `NotificationFetch` event
5. NotificationBloc calls `GetNotifications` usecase
6. Repository fetches from Supabase with user info join
7. Notifications displayed with NotificationCard widgets
8. User taps notification → marked as read → navigate to content
9. User marks all read → all notifications updated
