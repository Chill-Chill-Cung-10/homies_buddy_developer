-- ============================================================================
-- HOMIES BUDDY - MOMENT NOTE TABLE MIGRATION
-- Personal notes/moments feature
-- ============================================================================

-- ============================================================================
-- 1. MOMENT_NOTE TABLE
-- ============================================================================
-- Personal daily notes with optional media attachments
-- User creates notes for their own journal/diary

CREATE TABLE IF NOT EXISTS moment_note (
    id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    user_id         TEXT NOT NULL REFERENCES auth_users(id) ON DELETE CASCADE,
    author_name     TEXT NOT NULL DEFAULT '',
    author_avatar_url TEXT,
    text_content    TEXT NOT NULL DEFAULT '',
    media_urls      TEXT[] DEFAULT '{}',  -- Array of Firebase Storage URLs
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for user queries (get all notes by user_id)
CREATE INDEX IF NOT EXISTS idx_moment_note_user_id ON moment_note(user_id);

-- Index for date queries (get notes by created_at for calendar view)
CREATE INDEX IF NOT EXISTS idx_moment_note_created_at ON moment_note(created_at DESC);

-- Composite index for user + date queries (most common query pattern)
CREATE INDEX IF NOT EXISTS idx_moment_note_user_date ON moment_note(user_id, created_at DESC);

-- ============================================================================
-- 2. ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS
ALTER TABLE moment_note ENABLE ROW LEVEL SECURITY;

-- Allow anon key to perform all operations
-- (Since we're using Firebase Auth, not Supabase Auth, we rely on app-level filtering)
CREATE POLICY "moment_note_anon_all" ON moment_note
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- ============================================================================
-- DONE! moment_note table ready for use
-- ============================================================================
