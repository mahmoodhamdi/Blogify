-- ============================================
-- BLOGIFY DATABASE SCHEMA V3
-- ============================================
-- Adds: comments table with nested replies support

-- ============================================
-- DROP EXISTING V3 OBJECTS (if re-running)
-- ============================================

-- Drop tables first (CASCADE drops triggers, policies, indexes)
DROP TABLE IF EXISTS public.comments CASCADE;

-- Drop functions (CASCADE to drop dependent triggers)
DROP FUNCTION IF EXISTS public.increment_comments_count() CASCADE;
DROP FUNCTION IF EXISTS public.decrement_comments_count() CASCADE;

-- ============================================
-- ADD COMMENTS_COUNT TO BLOGS (if not exists)
-- ============================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'blogs' AND column_name = 'comments_count'
    ) THEN
        ALTER TABLE public.blogs ADD COLUMN comments_count INTEGER DEFAULT 0;
    END IF;
END $$;

-- ============================================
-- COMMENTS TABLE
-- ============================================

CREATE TABLE public.comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all comments"
    ON public.comments FOR SELECT
    USING (true);

CREATE POLICY "Users can insert own comments"
    ON public.comments FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments"
    ON public.comments FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments"
    ON public.comments FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_comments_blog_id ON public.comments(blog_id);
CREATE INDEX idx_comments_user_id ON public.comments(user_id);
CREATE INDEX idx_comments_parent_id ON public.comments(parent_id);

-- ============================================
-- FUNCTIONS: Auto-update comments_count
-- ============================================

CREATE OR REPLACE FUNCTION public.increment_comments_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.blogs
    SET comments_count = comments_count + 1
    WHERE id = NEW.blog_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.decrement_comments_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.blogs
    SET comments_count = GREATEST(comments_count - 1, 0)
    WHERE id = OLD.blog_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers
CREATE TRIGGER update_comments_count_on_insert
    AFTER INSERT ON public.comments
    FOR EACH ROW EXECUTE FUNCTION public.increment_comments_count();

CREATE TRIGGER update_comments_count_on_delete
    AFTER DELETE ON public.comments
    FOR EACH ROW EXECUTE FUNCTION public.decrement_comments_count();

-- ============================================
-- VERIFY SCHEMA
-- ============================================

SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
