-- ============================================
-- BLOGIFY DATABASE SCHEMA V2
-- ============================================
-- Adds: likes, bookmarks tables
-- Updates: blogs table with likes_count

-- ============================================
-- DROP EXISTING V2 OBJECTS (if re-running)
-- ============================================

-- Drop tables first (CASCADE drops triggers, policies, indexes)
DROP TABLE IF EXISTS public.likes CASCADE;
DROP TABLE IF EXISTS public.bookmarks CASCADE;

-- Drop functions (CASCADE to drop dependent triggers)
DROP FUNCTION IF EXISTS public.increment_likes_count() CASCADE;
DROP FUNCTION IF EXISTS public.decrement_likes_count() CASCADE;

-- ============================================
-- ADD LIKES_COUNT TO BLOGS (if not exists)
-- ============================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'blogs' AND column_name = 'likes_count'
    ) THEN
        ALTER TABLE public.blogs ADD COLUMN likes_count INTEGER DEFAULT 0;
    END IF;
END $$;

-- ============================================
-- LIKES TABLE
-- ============================================

CREATE TABLE public.likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);

-- Enable RLS
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all likes"
    ON public.likes FOR SELECT
    USING (true);

CREATE POLICY "Users can insert own likes"
    ON public.likes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own likes"
    ON public.likes FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_likes_user_id ON public.likes(user_id);
CREATE INDEX idx_likes_blog_id ON public.likes(blog_id);

-- ============================================
-- BOOKMARKS TABLE
-- ============================================

CREATE TABLE public.bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blog_id UUID NOT NULL REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id)
);

-- Enable RLS
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all bookmarks"
    ON public.bookmarks FOR SELECT
    USING (true);

CREATE POLICY "Users can insert own bookmarks"
    ON public.bookmarks FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks"
    ON public.bookmarks FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_bookmarks_user_id ON public.bookmarks(user_id);
CREATE INDEX idx_bookmarks_blog_id ON public.bookmarks(blog_id);

-- ============================================
-- FUNCTIONS: Auto-update likes_count
-- ============================================

CREATE OR REPLACE FUNCTION public.increment_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.blogs
    SET likes_count = likes_count + 1
    WHERE id = NEW.blog_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.decrement_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.blogs
    SET likes_count = GREATEST(likes_count - 1, 0)
    WHERE id = OLD.blog_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers
CREATE TRIGGER update_likes_count_on_insert
    AFTER INSERT ON public.likes
    FOR EACH ROW EXECUTE FUNCTION public.increment_likes_count();

CREATE TRIGGER update_likes_count_on_delete
    AFTER DELETE ON public.likes
    FOR EACH ROW EXECUTE FUNCTION public.decrement_likes_count();

-- ============================================
-- VERIFY SCHEMA
-- ============================================

SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
