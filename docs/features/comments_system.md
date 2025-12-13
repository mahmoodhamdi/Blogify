# Comments System Feature

## Overview
The Comments System allows users to add comments to blog posts, reply to other comments, and manage their own comments (edit/delete).

## Implementation Details

### Database Schema (schema_v3.sql)

#### Comments Table
```sql
CREATE TABLE public.comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Auto-updating comments_count
- Trigger functions automatically increment/decrement `comments_count` on the blogs table
- Uses SECURITY DEFINER for proper permissions

### Application Architecture

#### Domain Layer
- **Comment Entity**: Contains id, blogId, userId, parentId, content, timestamps, userName, userAvatarUrl, replies
- **CommentRepository Interface**: Defines methods for comment operations
- **Usecases**:
  - `GetComments`: Fetch comments for a blog with pagination
  - `AddComment`: Add a new comment or reply
  - `UpdateComment`: Edit a comment
  - `DeleteComment`: Delete a comment

#### Data Layer
- **CommentModel**: Extends Comment entity with JSON serialization
- **CommentRemoteDataSource**: Supabase API calls for comments
- **CommentRepositoryImpl**: Implements repository interface

#### Presentation Layer
- **CommentBloc Events**:
  - `CommentFetch`: Load comments for a blog
  - `CommentFetchMore`: Load more comments (pagination)
  - `CommentAdd`: Add new comment
  - `CommentUpdate`: Update existing comment
  - `CommentDelete`: Delete comment
- **CommentBloc States**:
  - `CommentInitial`
  - `CommentLoading`
  - `CommentLoaded`
  - `CommentAdded`
  - `CommentUpdated`
  - `CommentDeleted`
  - `CommentFailure`

### UI Components

#### CommentsSection Widget
- Displays list of comments with replies
- Input field for adding comments
- Reply functionality (tap reply on any comment)
- Edit/delete options for user's own comments

#### CommentCard Widget
- Displays single comment with user avatar, name, date
- Shows nested replies with indentation
- Reply button (for top-level comments)
- Edit/delete menu (for comment owner)

#### CommentInput Widget
- Text field for comment content
- Submit button
- Reply indicator when replying
- Edit mode when editing

## How to Use

### Setup Database
Run `supabase/schema_v3.sql` in Supabase SQL Editor after schema_v2.sql.

### Adding Comments
1. Open any blog post
2. Scroll to the Comments section at the bottom
3. Type your comment in the input field
4. Tap the send button

### Replying to Comments
1. Tap "Reply" on any comment
2. Input field shows "Replying to [name]"
3. Type your reply and send
4. Reply appears nested under the original comment

### Editing Comments
1. Tap the menu (three dots) on your comment
2. Select "Edit"
3. Modify the content
4. Tap send to save

### Deleting Comments
1. Tap the menu on your comment
2. Select "Delete"
3. Confirm in the dialog
4. Comment and all its replies are removed

## Testing
Tests are located in:
- `test/features/comments/domain/usecases/get_comments_test.dart`
- `test/features/comments/domain/usecases/add_comment_test.dart`
- `test/features/comments/domain/usecases/delete_comment_test.dart`

Run tests with:
```bash
flutter test test/features/comments/
```

## Files Created

### Domain Layer
- `lib/features/comments/domain/entities/comment.dart`
- `lib/features/comments/domain/repositories/comment_repository.dart`
- `lib/features/comments/domain/usecases/get_comments.dart`
- `lib/features/comments/domain/usecases/add_comment.dart`
- `lib/features/comments/domain/usecases/update_comment.dart`
- `lib/features/comments/domain/usecases/delete_comment.dart`

### Data Layer
- `lib/features/comments/data/models/comment_model.dart`
- `lib/features/comments/data/datasources/comment_remote_data_source.dart`
- `lib/features/comments/data/repositories/comment_repository_impl.dart`

### Presentation Layer
- `lib/features/comments/presentation/bloc/comment_bloc.dart`
- `lib/features/comments/presentation/bloc/comment_event.dart`
- `lib/features/comments/presentation/bloc/comment_state.dart`
- `lib/features/comments/presentation/widgets/comment_card.dart`
- `lib/features/comments/presentation/widgets/comment_input.dart`
- `lib/features/comments/presentation/widgets/comments_section.dart`

### Database
- `supabase/schema_v3.sql`

### Modified Files
- `lib/features/blog/domain/entities/blog.dart` (added commentsCount)
- `lib/features/blog/data/models/blog_model.dart` (added commentsCount)
- `lib/features/blog/presentation/pages/blog_viewer_page.dart` (added CommentsSection)
- `lib/init_dependencies.dart` (added comment imports)
- `lib/init_dependencies.main.dart` (added _initComments)

## Architecture Flow
1. User opens blog post → CommentsSection initializes
2. CommentsSection dispatches `CommentFetch` event
3. CommentBloc calls `GetComments` usecase
4. Repository fetches from Supabase (top-level + replies)
5. Comments displayed with CommentCard widgets
6. User adds comment → `CommentAdd` event → refresh comments
7. User edits/deletes → respective events → UI updates
