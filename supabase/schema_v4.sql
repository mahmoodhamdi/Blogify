-- ============================================
-- BLOGIFY DATABASE SCHEMA V4
-- ============================================
-- Adds: notifications table

-- ============================================
-- DROP EXISTING V4 OBJECTS (if re-running)
-- ============================================

-- Drop tables first (CASCADE drops triggers, policies, indexes)
DROP TABLE IF EXISTS public.notifications CASCADE;

-- Drop functions (CASCADE to drop dependent triggers)
DROP FUNCTION IF EXISTS public.create_like_notification() CASCADE;
DROP FUNCTION IF EXISTS public.create_comment_notification() CASCADE;

-- ============================================
-- NOTIFICATIONS TABLE
-- ============================================

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

-- Enable RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own notifications"
    ON public.notifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Anyone can insert notifications"
    ON public.notifications FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Users can update own notifications"
    ON public.notifications FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own notifications"
    ON public.notifications FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at DESC);

-- ============================================
-- TRIGGER: Create notification on like
-- ============================================

CREATE OR REPLACE FUNCTION public.create_like_notification()
RETURNS TRIGGER AS $$
DECLARE
    blog_owner_id UUID;
    blog_title TEXT;
    from_user_name TEXT;
BEGIN
    -- Get blog owner and title
    SELECT poster_id, title INTO blog_owner_id, blog_title
    FROM public.blogs WHERE id = NEW.blog_id;

    -- Get the name of the user who liked
    SELECT name INTO from_user_name
    FROM public.profiles WHERE id = NEW.user_id;

    -- Don't notify if user likes their own blog
    IF blog_owner_id != NEW.user_id THEN
        INSERT INTO public.notifications (user_id, type, title, message, blog_id, from_user_id)
        VALUES (
            blog_owner_id,
            'like',
            'New Like',
            from_user_name || ' liked your blog "' || LEFT(blog_title, 30) || '"',
            NEW.blog_id,
            NEW.user_id
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS create_like_notification_trigger ON public.likes;
CREATE TRIGGER create_like_notification_trigger
    AFTER INSERT ON public.likes
    FOR EACH ROW EXECUTE FUNCTION public.create_like_notification();

-- ============================================
-- TRIGGER: Create notification on comment
-- ============================================

CREATE OR REPLACE FUNCTION public.create_comment_notification()
RETURNS TRIGGER AS $$
DECLARE
    blog_owner_id UUID;
    blog_title TEXT;
    parent_comment_user_id UUID;
    from_user_name TEXT;
BEGIN
    -- Get the name of the commenter
    SELECT name INTO from_user_name
    FROM public.profiles WHERE id = NEW.user_id;

    -- If this is a reply
    IF NEW.parent_id IS NOT NULL THEN
        -- Get parent comment owner
        SELECT user_id INTO parent_comment_user_id
        FROM public.comments WHERE id = NEW.parent_id;

        -- Notify parent comment owner (if not self-reply)
        IF parent_comment_user_id != NEW.user_id THEN
            INSERT INTO public.notifications (user_id, type, title, message, blog_id, comment_id, from_user_id)
            VALUES (
                parent_comment_user_id,
                'reply',
                'New Reply',
                from_user_name || ' replied to your comment',
                NEW.blog_id,
                NEW.id,
                NEW.user_id
            );
        END IF;
    ELSE
        -- Top-level comment - notify blog owner
        SELECT poster_id, title INTO blog_owner_id, blog_title
        FROM public.blogs WHERE id = NEW.blog_id;

        -- Don't notify if user comments on their own blog
        IF blog_owner_id != NEW.user_id THEN
            INSERT INTO public.notifications (user_id, type, title, message, blog_id, comment_id, from_user_id)
            VALUES (
                blog_owner_id,
                'comment',
                'New Comment',
                from_user_name || ' commented on your blog "' || LEFT(blog_title, 30) || '"',
                NEW.blog_id,
                NEW.id,
                NEW.user_id
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS create_comment_notification_trigger ON public.comments;
CREATE TRIGGER create_comment_notification_trigger
    AFTER INSERT ON public.comments
    FOR EACH ROW EXECUTE FUNCTION public.create_comment_notification();

-- ============================================
-- VERIFY SCHEMA
-- ============================================

SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
